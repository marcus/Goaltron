class Article < Content    
  acts_as_taggable
    
  validates_presence_of :title, :user_id

  has_permalink :title
  after_save    :save_assigned_sections

  has_many :assigned_sections, :dependent => :destroy
  has_many :sections, :through => :assigned_sections, :order => 'sections.name'
  has_many :comments
  
  def has_section?(section)
    #return @new_sections.include?(section.id.to_s) if !@new_sections.blank?
    #(new_record? && section.home?) || sections.include?(section)
    begin self.sections.find(section.id)
      true
    rescue
      false
    end
  end
  
  def published?
    !new_record? && !published_at.nil?
  end
  
  def pending?
    !published? || Time.now.to_date < published_at
  end
  
  def status
    pending? ? :pending : :published
  end

  def section_ids=(new_sections)
    @new_sections = new_sections
  end
  
  protected
    
    def save_assigned_sections
      return if @new_sections.nil?
      assigned_sections.each do |assigned_section|
        @new_sections.delete(assigned_section.section_id.to_s) || assigned_section.destroy
      end
      
      if !@new_sections.blank?
        Section.find(:all, :conditions => ['id in (?)', @new_sections]).each { |section| assigned_sections.create :section => section }
        sections.reset
      end
    
      @new_sections = nil
    end

end