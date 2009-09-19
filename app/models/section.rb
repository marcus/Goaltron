class Section < ActiveRecord::Base
  ARTICLES_COUNT_SQL = 'INNER JOIN assigned_sections ON contents.id = assigned_sections.article_id INNER JOIN sections ON sections.id = assigned_sections.section_id'.freeze unless defined?(ARTICLES_COUNT)
  validates_presence_of   :name
  has_many :assigned_sections, :dependent => :delete_all
  has_many :articles, :order => 'position', :through => :assigned_sections do
    def find_by_position(options = {})
      find(:first, { :conditions => ['contents.published_at <= ? AND contents.published_at IS NOT NULL', Time.now.utc] } \
        .merge(options))
    end
  end

  class << self
    # scopes a find operation to return only paged sections
    def find_paged(options = {})
      with_scope :find => { :conditions => ['show_paged_articles = ?', true] } do
        block_given? ? yield : find(:all, options)
      end
    end

    def articles_count
      Article.count :all, :group => :section_id, :joins => ARTICLES_COUNT_SQL
    end

  end

  # orders articles assigned to this section
  def order!(*sorted_ids)
    transaction do
      sorted_ids.flatten.each_with_index do |article, pos|
        assigned_sections.detect { |s| s.article_id.to_s == article.to_s }.update_attributes(:position => pos)
      end
      save
    end
  end
  
  def paged?
    show_paged_articles?
  end

end
