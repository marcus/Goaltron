class DailyGoalsController < ApplicationController
  before_filter :verify_logged_in
  
  verify :method => :post, :only => [ :create, :update, :activate, :deactivate, :destroy ],
         :redirect_to => { :action => :list }
  
  def list
    @active_goals = DailyGoal.active_goals(session[:user])
    @inactive_goals = DailyGoal.inactive_goals(session[:user])
  end
 
  def create    
    goal = DailyGoal.new(params[:daily_goal])
    goal.user_id = session[:user]
    goal.active = true
    goal.save
    
    update_goals_html
  end

  def update
    @goal = DailyGoal.find_by_id(params[:id])
    render :layout => false
  end
  
  def edit
    goal = DailyGoal.find(params[:id])
    goal.update_attributes(params[:goal])
    list
    respond_to do |format|
      format.js {
        render :update do |page|
          page.replace_html("active_goals", :partial => 'active_goal', :collection => @active_goals)
          page.replace_html("inactive_goals", :partial => 'inactive_goal', :collection => @inactive_goals)
          page.replace_html("update_goal", :partial => 'goal_saved')
        end
      }
    end
  end
  
  def activate
    set_active_switch(DailyGoal.find_by_id(params[:id]), true)
    update_goals_html
  end

  def deactivate
    set_active_switch(DailyGoal.find_by_id(params[:id]), false)
    update_goals_html
  end

  def destroy
      goal = DailyGoal.find_by_id(params[:id])
      
      # Check to make sure user owns this goal we're going to delete
      goal.destroy if (goal.user_id == session[:user])
      
      update_goals_html
  end

  protected
    
  def set_active_switch(goal, active)
    goal = DailyGoal.find_by_id(params[:id])
    goal.active = active
    goal.save
  end
  
  def update_goals_html
    list
    respond_to do |format|
      format.js {
        render :update do |page|
          page.replace_html("active_goals", :partial => 'active_goal', :collection => @active_goals)
          page.replace_html("inactive_goals", :partial => 'inactive_goal', :collection => @inactive_goals)
        end
      }
    end
  end
end
