def status_icon
  @status_icon ||= { :unpublished => %w(orange unpublished.png),
                     :pending     => %w(yellow pending.png),
                     :published   => %w(green accept.png) }
end
                     
def published_at_for(article)
 return 'not published' unless article && article.published?
 article.published_at.to_s(article.published_at.year == Time.now.year ? :stub : :mdy)
end