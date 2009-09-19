class GoalsController < ApplicationController
  in_place_edit_for :goal, :description
  in_place_edit_for :goal, :information

  before_filter :verify_logged_in
  
  # Methods for in place editing
  def set_goal_description
    @goal = Goal.find(params[:id])
    previous_name = @goal.description
    @goal.description = params[:value]
    @goal.description = previous_name unless @goal.save
    render :text => @goal.description
  end
  
  def set_goal_information
    @goal = Goal.find(params[:id])
    previous_name = @goal.information
    @goal.information = params[:value]
    @goal.information = previous_name unless @goal.save
    render :text => @goal.information
  end

  def index
    list
    render :action => 'list'
  end

  def list
    # FIXME: Isn't there a better way than goals.completed_at IS NULL ? (It's all over...)
    @goals = Goal.find_all_by_user_id(session[:user], :conditions => ["goals.completed_at IS NULL"], :order => 'position ASC')
    user = User.find(session[:user])
    @goal_edited = false
    @completed_goals = user.goals.find(:all, :conditions => ["goals.completed_at IS NOT NULL"], :order => 'position ASC')
  end

  def show
    verify_user
    @user = User.find(session[:user])
    @goal = Goal.find(params[:id])
    @step_edited = false
    @entry_edited = false
    @steps = @goal.goal_steps.find(:all, :conditions => ["goal_steps.completed_at IS NULL"])
    @completed_steps = @goal.goal_steps.find(:all, :conditions => ["goal_steps.completed_at IS NOT NULL"])
    @entries = @goal.goal_entries.find(:all, :limit => 15, :order => 'created_at DESC')
  end
  
  def create_goal
    if (params[:goal][:description] != "")
      @goal_edited = false
      @goal = Goal.new(params[:goal])
      @goal.user_id = session[:user]
      @goal.information = "Click here to edit this goals description" if (params[:goal][:information] == "")
      @goal.save
      render :update do |page|
        page.insert_html :bottom, 'goals_list', :partial => 'goal_item', :locals => {:goal => @goal}
        page.replace_html 'add_goal', :partial => 'goal_form'
        page.replace_html 'sortable', :partial => 'sortable_goal', :locals => {:user => @goal.user}
      end
    else
      render :nothing => true
    end
  end
  
  def delete_goal
    Goal.find(params[:id]).destroy
    render :update do |page|
      page.visual_effect :fade, params[:id].to_s.insert(0,"complete_goal_")
    end
  end
 
  def complete_goal
    @goal = Goal.find(params[:id])
    @goal.completed_at = Time.now
    @goal.move_to_bottom
    @goal.save
    render :update do |page|
      page.visual_effect :drop_out, params[:id].to_s.insert(0,"goal_")
      page.insert_html :bottom, 'completed_goals_list', :partial => 'completed_goal_item', :locals => {:goal => @goal}
    end
  end
  
  def uncomplete_goal
    @goal_edited = false
    @goal = Goal.find(params[:id])
    @goal.completed_at = "NULL"
    @goal.move_to_bottom
    @goal.save
    render :update do |page|
      page.visual_effect :fade, params[:id].to_s.insert(0,"complete_goal_")
      page.insert_html :bottom, 'goals_list', :partial => 'goal_item', :locals => {:goal => @goal}
      page.replace_html 'sortable', :partial => 'sortable_goal', :locals => {:user => @goal.user}
    end
  end
  
  def sort_goals
    user = User.find(session[:user])
    @goals = user.goals.find(:all, :conditions => ["goals.completed_at IS NULL"])
    @goals.each{|goal|
        goal.position = params['goals_list'].index(goal.id.to_s)+1
        goal.save
    }
    render :nothing => true
  end
  
  def show_completed_goals
    user = User.find(session[:user])
    @goals = user.goals.find(:all, :conditions => ["goals.completed_at IS NOT NULL"])
  end
  
  def sort_steps
    @goal = Goal.find(params[:id])
    @steps = @goal.goal_steps.find(:all, :conditions => ["goal_steps.completed_at IS NULL"])
    @steps.each{|step|
      step.position = params['steps_list'].index(step.id.to_s)+1
      step.save
    }
    render :nothing => true
  end
  
  def create_step
    if (params[:step][:description] != "")
      @step = GoalStep.new(params[:step])
      @step.save
      @step_edited = false
      render :update do |page|
        page.insert_html :bottom, 'steps_list', :partial => 'step_item', :locals => {:step => @step}
        page.replace_html 'add_step', :partial => 'step_form', :locals => {:goal => @step.goal}
        page.replace_html 'sortable', :partial => 'sortable_element', :locals => {:goal => @step.goal}
      end
    else
      render :nothing => true      
    end
  end
  
  def delete_step
    GoalStep.find(params[:id]).destroy
    render :update do |page|
      page.visual_effect :fade, params[:id].to_s.insert(0,"complete_step_") 
    end
  end
  
  def complete_step
    @step = GoalStep.find(params[:id])
    # TODO: What if completed_at is already set? How can we handle sanity checks?
    # Not sure why it matters if it's already set here--if it was set then this overwrites it with the new date.
    @step.completed_at = Time.now
    @step.move_to_bottom
    @step.save
    render :update do |page|
      page.visual_effect :drop_out, params[:id].to_s.insert(0,"step_")
      page.insert_html :bottom, 'completed_steps_list', :partial => 'completed_step_item', :locals => {:step => @step}
    end
  end
  
  def uncomplete_step
    @step_edited = false
    @step = GoalStep.find(params[:id])
    @goal = @step.goal
    # TODO: What if completed_at is already NULL? How can we handle sanity checks?
    @step.completed_at = "NULL"
    @step.move_to_bottom
    @step.save
    render :update do |page|
      page.visual_effect :slide_up, params[:id].to_s.insert(0,"complete_step_")
      page.insert_html :bottom, 'steps_list', :partial => 'step_item', :locals => {:step => @step}
      page.replace_html 'sortable', :partial => 'sortable_element', :locals => {:goal => @goal}
    end
  end
  
  def show_step_edit
    @step = GoalStep.find(params[:id])
    render :update do |page|
      page.replace_html params[:id].to_s.insert(0,"step_"), :partial => 'edit_step', :locals => {:step => @step}
    end
  end
  
  def edit_step
    @step_edited = true
    @step = GoalStep.find(params[:id])
    @goal = @step.goal
    @step.update_attributes(params[:step])
    @step.save
    render :update do |page|
      page.replace_html params[:id].to_s.insert(0,"step_"), :partial => 'step_item', :locals => {:step => @step}
      page.replace_html 'sortable', :partial => 'sortable_element', :locals => {:goal => @goal}
    end
  end
  
  def show_completed_steps
    @steps = @goal.steps.find(:all, :conditions => ["steps.completed_at IS NOT NULL"])
  end
  
  def create_entry
    if (params[:entry][:description] != "")
      @entry_edited = false
      @entry = GoalEntry.new(params[:entry])
      @goal = @entry.goal
      @entry.save
      render :update do |page|
        page.insert_html :top, 'entries_list', :partial => 'entry_item', :locals => {:entry => @entry}
        page.replace_html 'add_entry', :partial => 'entry_form',:locals => {:goal => @goal}
      end
    else
      # TODO: Should we render something here? (and all over...)
      
      render :nothing => true
    end
  end
  
  def show_entry_edit
    @entry = GoalEntry.find(params[:id])
    render :update do |page|
      page.replace_html params[:id].to_s.insert(0,"entry_"), :partial => 'edit_entry', :locals => {:entry => @entry}
    end
  end
  
  def edit_entry
    @entry_edited = true
    @entry = GoalEntry.find(params[:id])
    @entry.update_attributes(params[:entry])
    @entry.save
    render :update do |page|
      page.replace_html params[:id].to_s.insert(0,"entry_"), :partial => 'entry_item', :locals => {:entry => @entry}
    end
  end
  
  def delete_entry
    GoalEntry.find(params[:id]).destroy
    render :update do |page|
      page.visual_effect :fade, params[:id].to_s.insert(0,"entry_")
    end
  end
  
  # Entries page
  def entries
    verify_user
    @entry_edited = false
    @goal = Goal.find(params[:id])
    @entries = GoalEntry.find_all_by_goal_id(@goal.id, :order => 'created_at DESC')
  end
  
  private
  
  # An attempt at security.
  def verify_user
    @goal = Goal.find(params[:id])
    if @goal.user_id != session[:user]
      redirect_to :controller => "goals", :action => "index"
      flash[:notice] = 'Error: That goal does not exist.'
    end
  end
  
end
