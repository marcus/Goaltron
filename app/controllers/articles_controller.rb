class ArticlesController < ApplicationController
  tagging_helper_for Article
  before_filter :verify_logged_in
  before_filter :convert_times, :only => [:create, :update, :upload]
  before_filter :check_for_draft,  :only => [:create, :update, :upload]
  before_filter :load_sections, :only => [:new, :edit]
  before_filter :load_user, :except => [:new]
  before_filter :get_article, :only => [:edit, :update]
    
  uses_tiny_mce(:options => {:theme => 'advanced',
                             :browsers => %w{msie gecko},
                             :theme_advanced_toolbar_location => "top",
                             :theme_advanced_resizing => true,
                             :height => 400,
                             :theme_advanced_resize_horizontal => true,
                             :paste_auto_cleanup_on_paste => true,
                             :theme_advanced_buttons1 => %w{code bold italic separator justifyleft justifycenter justifyright indent outdent separator bullist numlist separator link unlink undo redo},
                             :theme_advanced_buttons2 => [],
                             :theme_advanced_buttons3 => [],
                             :plugins => %w{contextmenu paste}},
                :only => [:update, :edit, :create, :new])

  def list
    @article_pages = Paginator.new self, @user.articles.count(:all, article_options), 30, params[:page]
    @articles      = @user.articles.find(:all, :order => 'contents.published_at DESC', :select => 'contents.*', 
                       :limit   =>  @article_pages.items_per_page,
                       :offset  =>  @article_pages.current.offset)
    @sections = Section.find(:all)
  end
  
  def index
    @article_pages = Paginator.new self, Article.count(:all, article_options), 30, params[:page]
    @articles      = Article.find(:all, :order => 'contents.published_at DESC', :select => 'contents.*', 
                       :limit   =>  @article_pages.items_per_page,
                       :offset  =>  @article_pages.current.offset,
                       :conditions => ['published_at IS NOT NULL AND published_at <= ?', Time.now])
    @sections = Section.find(:all)
  end

  def show
    @article = @article = Article.find(params[:id])
    # TODO is this right? Check the logic when the headcold is gone.
    if @article.user != @user && (@article.published_at == nil || @article.published_at.to_time > Time.now)
      redirect_to :action => 'index'
      flash[:notice] = "Article not found."
    end
  end

  def new
    @article = Article.new
    @article.published_at = Time.now
  end

  def edit
    @published = @article.published?
    @article.published_at = @article.published_at || Time.now
  end

  def create
    @article = @user.articles.create params[:article]
    @article.published_at = params[:article][:published_at]
    @article.save!
    
    # TODO - Tags. Save.
    ## saved = @article.save
    ## @article.tags.add(params[:tags]) if saved and !params[:tags].blank?

    flash[:notice] = "Your article was saved"
    redirect_to :action => 'edit', :id => @article.id
  rescue ActiveRecord::RecordInvalid
    load_sections
    render :action => 'list'
  end
  
  def update
    @article.attributes = params[:article]
    @article.published_at = params[:article][:published_at]
    @article.save
    flash[:notice] = "Your article was updated"
    redirect_to :action => 'edit', :id => params[:id]
  rescue ActiveRecord::RecordInvalid
    load_sections
    render :action => 'list'
  end

  def destroy
    if @article.user_id == @user.id
      @article.destroy
    end
    render :update do |page|
      page.redirect_to :action => 'list'
    end
  end

  protected
    def get_article
      begin
        @article = @user.articles.find(params[:id])
      rescue
        redirect_to :action => 'list'
        flash[:notice] = "Article not found."
      end
    end
  
    def load_sections
      @sections = Section.find(:all)
    end
    
    def load_user
      if session[:user] != nil
        @user = User.find(session[:user])
      else
        flash[:notice] = "Please login first"
      end
    end
    
    def check_for_draft
      params[:article] ||= {}      
      params[:article][:published_at] = nil if params[:draft] == "1"
      true
    end
    
    def convert_times
        date = Time.parse_from_attributes(params[:article], :published_at, :local)
        params[:article][:published_at] = date
    end
    
    def article_options(options = {})
      if @article_options.nil?
        @article_options = {}
        section_id       = params[:section].to_i
        case params[:filter]
          when 'title'
            @article_options[:conditions] = Article.send(:sanitize_sql, ["LOWER(contents.title) LIKE ?", "%#{params[:q].downcase}%"])
          when 'body'
            @article_options[:conditions] = Article.send(:sanitize_sql, ["LOWER(contents.excerpt) LIKE :q OR LOWER(contents.body) LIKE :q", {:q => "%#{params[:q].downcase}%"}])
          when 'tags'
            @article_options[:joins] = "INNER JOIN taggings ON taggings.taggable_id = contents.id and taggings.taggable_type = 'Content' INNER JOIN tags on taggings.tag_id = tags.id"
            @article_options[:conditions] = Article.send(:sanitize_sql, ["tags.name IN (?)", Tag.parse(params[:q])])
          when 'draft'
            @article_options[:conditions] = 'published_at is null'
        end unless params[:q].blank? && params[:filter] != 'draft'
        if section_id > 0
          cond = Article.send(:sanitize_sql, ['assigned_sections.section_id = ?', params[:section]])
          @article_options[:conditions] = @article_options[:conditions] ? "(#{@article_options[:conditions]}) AND (#{cond})" : cond
        end
      end
      @article_options.merge options
    end
    
end