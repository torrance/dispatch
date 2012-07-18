class SearchController < ApplicationController
  def index
    # By default, search for empoty string.
    search_string = params[:q] || ''

    begin
      @search = search(search_string)
      # For our convenience in the view, pull out the models.
      @contents = @search.hits.map(&:result)

      @facet_types = [
        { name: 'type', attribute: 'type' },
        { name: 'category', attribute: 'category' },
        { name: 'tag', attribute: 'tag_list' },
        { name: 'date', attribute: 'created_at' }
      ]
    rescue Errno::ECONNREFUSED
      render 'error'
    end
  end

  protected
  def search(search_string)
    Sunspot.search(Article) do |s|
      s.fulltext search_string

      # Configure facets.
      s.facet :category
      s.with(:category).equal_to(params[:category]) if params[:category].present?

      s.facet :tag_list
      s.with(:tag_list).equal_to(params[:tag_list]) if params[:tag_list].present?

      s.facet :type
      s.with(:type).equal_to(params[:type]) if params[:type].present?

      # The year facet requires a bit more work.
      # First set up the appropriate ranges.
      now = Time.now
      year_ranges = []
      (0..5).each do |years|
        year = (now - years.year).beginning_of_year
        year_ranges << { name: year.strftime("%Y"), range: year..(year + 1.year) }
      end

      # Create the facet rows for our time ranges.
      s.facet :created_at do
        year_ranges.each do |y|
          row y[:name] do
            with :created_at, y[:range]
          end
        end
      end

      # And now filter the current search if we have a valid time range.
      year_ranges.each do |y|
        s.with(:created_at).between(y[:range]) if params[:created_at] == y[:name]
      end

      s.paginate :page => params[:page], :per_page => 15
    end
  end
end
