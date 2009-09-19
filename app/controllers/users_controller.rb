class UsersController < ApplicationController
  # Placeholder for new.rhtml
  def new
  end

  def create
    # Create new user entry in table
    @user = User.new(params[:user])   
    @user.save
    self.current_user = @user

    # Add default daily_goals now that the user is created.
    default_goals = YAML::load(File.open('./config/default_goals.yml'));
    default_goals.each_pair{|name,attrs|
      new_goal = DailyGoal.new
      new_goal.name = name
      new_goal.description = attrs['description']
      new_goal.active = attrs['recommended']
      new_goal.user_id = @user.id
      new_goal.save
    }
    @user.save
    
    redirect_back_or_default('/')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end
  
  def edit
    @user = User.find(session[:user])
  end
  
  def update
    @user = User.find(params[:id])
    respond_to do |format| 
      if @user.update_attributes(params[:user]) 
        format.html { redirect_to user_url(@user) } 
      else 
        format.html { render :action => "edit" } 
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end
end
