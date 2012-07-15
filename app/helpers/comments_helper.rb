module CommentsHelper
  def comment_date(date)
    if date < date + 7.days
      time_ago_in_words(date)
    else
      date.strftime "#{date.day.ordinalize} %B %Y"
    end
  end

  def hide_comment_toggle(comment)
    text = comment.visible? ? 'Hide' : 'Unhide'
    new_status = comment.visible? ? 0 : 1
    path = content_comment_path(comment.content_id, comment, :comment => { :status => new_status })
    link_to text, path, :method => :put, :remote => true, :format => :js
  end
end
