module Dispatch
  class ContentFilter
    include Singleton

    def initialize
      @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
        :filter_html => true, :no_images => true, :hard_wrap => true,
        :auto_link => true, :no_intra_emphasis => true,
        :space_after_headers => true, :superscript => true)
    end

    def render(text)
      @markdown.render(text).html_safe
    end
  end
end

