class CommentsController < ApplicationController
  before_filter :get_current_user
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.article_id = params[:article]
    @comment.user = @user
    @comment.save!
    
    if params[:parent] != nil && params[:parent] != "0"
      @parent = Comment.find(params[:parent])
      @comment.move_to_child_of @parent
    end
    
    if @parent == nil
      form_div = "form_comment_0"
    else
      form_div = dom_id(@parent, "form")
    end
    
    respond_to do |format|
      format.js {
        render :update do |page|
         page.replace_html(form_div, :partial => 'comment', :locals => {:comment => @comment})
        end
      }
    end
  end
  
  def reply
    @article = params[:article]
    
    if params[:parent] != 0 && params[:parent] != nil
      @parent = params[:parent]
      comment = Comment.find(params[:parent])
    else
      comment = 0
    end
    
    render :update do |page|
      page.replace_html(dom_id(comment, "reply_form"), :partial => 'form', :locals => {:article => @article})
      page.replace_html(dom_id(comment, "comment_reply"), "")
    end
  end
  
  def cancel
    comment = Comment.find(params[:comment])
    
    respond_to do |format|
      format.js {
        render :update do |page|
          page.replace_html(dom_id(comment, "form"), "")
          page.replace_html(dom_id(comment, "comment_reply"), :partial => 'reply_link', :locals => {:comment => comment})
        end
      }
    end
    
  end
  
  private
  def get_current_user
    @user = User.find(session[:user])
  end
end