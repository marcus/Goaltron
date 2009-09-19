class DailyDayEntriesController < ApplicationController
  before_filter :verify_logged_in
  uses_tiny_mce(:options => {:theme => 'advanced',
                             :browsers => %w{msie gecko},
                             :theme_advanced_toolbar_location => "top",
                             :theme_advanced_resizing => true,
                             :height => 200,
                             :theme_advanced_resize_horizontal => true,
                             :paste_auto_cleanup_on_paste => true,
                             :theme_advanced_buttons1 => %w{code bold italic separator justifyleft justifycenter justifyright indent outdent separator bullist numlist separator link unlink undo redo},
                             :theme_advanced_buttons2 => [],
                             :theme_advanced_buttons3 => [],
                             :plugins => %w{contextmenu paste}},
                :only => [:index, :update, :edit])

  def index
    user = User.find(session[:user])
    
    # Get registration date
    @first_date = user.created_at.to_date
  
    # Get date parameter if:
    # => it exists
    # => it's not in the future
    # otherwise: get whichever comes last:
    # => timezone's "now" or registration date
    @date = [params[:date] && params[:date].to_date <= Time.now.to_date ? 
      params[:date].to_date : Time.now.to_date, @first_date].max;
    
    # FIXME: This shouldn't have to chomp the date string like this. to_date on line 8 isn't working    
    # FIXME: The set is being found twice in this function (see the development.log) this needs optimization
    @day_entry = user.daily_day_entries.find_or_create_by_day(@date.to_s[0..9])
    @goal_entries = @day_entry.active_goal_entries
  end
  
  def update
    # Get goal entry we are updating
    goal_entry = DailyGoalEntry.find(params[:id])
    
    # Day entry should already be correct, but might as well enforce
    @day_entry = goal_entry.daily_day_entry
    
    # Check to make sure user_id belongs to user
    # If true, then save new goal_entry completed status to DB.
    if goal_entry.daily_day_entry.user_id == session[:user]
      goal_entry.completed = params[:completed]
      goal_entry.save  
    
      # Update the view to reflect new score.
      respond_to do |format|
        format.js {
          render :update do |page|
            page.replace(dom_id(goal_entry), :partial => 'goal_entry', :locals => {
              :goal_entry => goal_entry})
            page.replace("score", :partial => 'score', :locals => {
              :score => @day_entry.calculated_score,
              :total => @day_entry.daily_goal_entries.length.to_s })
            page.visual_effect :highlight, 'score'
          end 
        }
      end
    # If somehow they tried to update a goal_entry they don't own, go to new?
    else
      redirect_to '/sessions/new'
    end	
  end
  
  def update_journal
    @daily_day_entry = DailyDayEntry.find(params[:id])
    @daily_day_entry.update_attributes(params[:daily_day_entry])
     respond_to do |format|
        format.js {
          render :update do |page|
            page.replace("journal", :partial => 'journal_entry', :locals => {
              :daily_day_entry => @daily_day_entry})
          end 
        }
      end
  end
  
  def history
    @user = User.find(session[:user])
    @dates = Array.new
    
    #TODO: This is probably not the best way to make this comparision (chomping the string)
    for d in @user.created_at.to_date..Time.now.to_date 
      @dates.push(d.to_s[0..9])
    end

    @sets = Array.new
    @dates.each do |d| 
      @sets.push(@user.daily_day_entries.find_or_create_by_day(d))
    end
    
  end
  
end
