module CommentsHelper
  def comment_date(date)
    if DateTime.now < date + 7.days
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

  def hidden_comments?(comments)
    comments.each do |c|
      return true if c.hidden?
    end
    return false
  end

  def comment_text(comments, content, show_hidden_comments)
    text = []

    if content.hidden? || content.locked?
      text.append "Commenting has now closed on this #{@type}."
    else
      if comments.empty?
        text.append "There are no comments yet."
      end
      if !current_user
        text.append "You need to be #{link_to "logged in", login_path} to comment."
      end
    end

    if !show_hidden_comments && hidden_comments?(comments)
      text.append link_to("Show hidden comments.", content_path(content, :show_hidden_comments => 1))
    end

    text.join(" ").html_safe
  end
end
