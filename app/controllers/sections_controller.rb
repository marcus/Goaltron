class SectionsController < ApplicationController
  
  def show
    begin
      @articles = Section.find(params[:id]).articles
    rescue
      @articles = Section.find_by_name(params[:id]).articles
    end
  end
  
end