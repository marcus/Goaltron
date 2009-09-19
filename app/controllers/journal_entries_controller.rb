class JournalEntriesController < ApplicationController
  before_filter :verify_logged_in
  tagging_helper_for JournalEntry
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
                :only => [:update, :edit])
  
  def index
    user = User.find(session[:user])
    
    # Get registration date
    @first_date = user.created_at.to_date
  
    # Get date parameter if, it exists, it's not in the future
    # otherwise: get whichever come's last:
    # => timezone's "now" or registration date
    @date = [params[:date] && params[:date].to_date <= Time.now.to_date ? 
      params[:date].to_date : Time.now.to_date, @first_date].max;
    
    @journal_entry = user.journal_entries.find_or_create_by_entry_date_and_user_id(@date.to_s[0..9], session[:user])
    
    if @journal_entry.good == nil && @journal_entry.bad == nil
      redirect_to :action => :edit, :id => @journal_entry
    end

  end

  # GET /journal_entries/1
  # GET /journal_entries/1.xml
  def show
    @journal_entry = JournalEntry.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @journal_entry.to_xml }
    end
  end

  # GET /journal_entries/1;edit
  def edit
    user = User.find(session[:user])
    @first_date = user.created_at.to_date

    @journal_entry = JournalEntry.find(params[:id])
  end


  # PUT /journal_entries/1
  # PUT /journal_entries/1.xml
  def update
    @journal_entry = JournalEntry.find(params[:id])

    respond_to do |format|
      if @journal_entry.update_attributes(params[:journal_entry])
        flash[:notice] = 'Journal entry was successfully updated.'
        format.html { redirect_to :action => 'index', :date => @journal_entry.entry_date }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @journal_entry.errors.to_xml }
      end
    end
  end
  
  def list
    @journal_entries = JournalEntry.paginate_all_by_user_id session[:user], :page => params[:page], :order => 'entry_date DESC'
    #@journal_entries = JournalEntry.find_all_by_user_id(session[:user], :order => 'entry_date DESC')
  end

end
