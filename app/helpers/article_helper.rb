module ArticleHelper

  def datetime(article)
    article.datetime
  end

  def display_date(article)
    article.display_date
  end

  def content(article)
    if request.xhr?
      article.content
    else
      article.description
    end
  end

end
