class ChangeArticleDefaultCategories < ActiveRecord::Migration
  # This will wreak havoc on a database with articles that have existing categories since the indexes are all going to be destroyed.
  def self.up
    s = Section.find(:all)
    for section in s
      section.destroy
    end
    
    as = AssignedSection.find(:all)
    for a in as
      a.destroy
    end
    
    s = Section.new
    s.name = "Ethics/Morals/Religion"
    s.save
     
    s = Section.new
    s.name = "Science"
    s.save
     
    s = Section.new
    s.name = "Liberal Arts"
    s.save
    
    s = Section.new
    s.name = "Government"
    s.save
    
    s = Section.new
    s.name = "Business"
    s.save
  end

  def self.down
    s = Section.find(:all)
    for section in s
      section.destroy
    end
    
    s = Section.new
    s.name = "Art"
    s.save
     
    s = Section.new
    s.name = "Biology"
    s.save
     
    s = Section.new
    s.name = "Books"
    s.save
    
    s = Section.new
    s.name = "Business"
    s.save
    
    s = Section.new
    s.name = "Design"
    s.save
    
    s = Section.new
    s.name = "Environment"
    s.save
    
    s = Section.new
    s.name = "Health"
    s.save
    
    s = Section.new
    s.name = "History"
    s.save
    
    s = Section.new
    s.name = "Knowledge"
    s.save
    
    s = Section.new
    s.name = "News"
    s.save
    
    s = Section.new
    s.name = "Philosophy"
    s.save
    
    s = Section.new
    s.name = "Books"
    s.save
    
    s = Section.new
    s.name = "Physics"
    s.save
    
    s = Section.new
    s.name = "Politics"
    s.save
    
    s = Section.new
    s.name = "Religion"
    s.save
    
    s = Section.new
    s.name = "Research"
    s.save
    
    s = Section.new
    s.name = "Science"
    s.save
    
    s = Section.new
    s.name = "Technology"
    s.save
  end
end
