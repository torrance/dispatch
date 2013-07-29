module ApplicationHelper
  # The below was copied from
  # https://github.com/ryanb/complex-form-examples/blob/master/app/helpers/application_helper.rb
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "DISPATCH.add_fields(\"#{association}\", \"#{escape_javascript(fields)}\")", :class => "add-field")
  end

  def content_filter(text)
    Dispatch::ContentFilter.instance.render text
  end

  def privileged_filter(text)
    Dispatch::ContentFilter.instance.render_privileged text
  end

  def simple_filter(text)
    auto_link simple_format(html_escape text), :html => { :rel => 'nofollow'}
  end

  def current_url
    "http://#{request.host + request.fullpath}"
  end
end
