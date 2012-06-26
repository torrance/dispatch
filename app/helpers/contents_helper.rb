module ContentsHelper
  def link_to_author(article)
    if not article.user.blank?
      link_to article.author_name, article.user
    else
      article.author_name
    end
  end
end
