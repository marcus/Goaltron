class AddDefaultToSections < ActiveRecord::Migration
  def self.up
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

  def self.down
    s = Section.find(:all)
    for section in s
      section.destroy
    end
  end
end
