class ContentsController < ApplicationController
  check_authorization # Ensure cancan validation on every controller method
  before_filter :initialize_content_names

  def index
    @contents = Content.recent.page(params[:page]).per(25)
    authorize! :read, @contents.first
  end

  def new
    @content = params[:type].constantize.new { |c| c.user = current_user }
    2.times { |weight| @content.images.build(:weight => weight) }
    authorize! :create, @content
  end

  def create
    @content = params[:type].constantize.new(params[content_type_key])
    @content.user = current_user
    authorize! :create, @content

    if (current_user || valid_captcha?(@content)) && @content.save
      redirect_to content_path(@content), notice: "Your #{@type} was successfully created."
    else
      (998..999).each { |weight| @content.images.build(:weight => weight) }
      render action: "new"
    end
  end

  def edit
    @content = Content.find(params[:id])
    (998..999).each { |weight| @content.images.build(:weight => weight) }
    authorize! :update, @content
  end

  def update
    @content = Content.find(params[:id])
    authorize! :update, @content

    if @content.update_attributes(params[content_type_key])
      redirect_to content_path(@content), notice: "Your #{@type} was sucessfully updated."
    else
      (998..999).each { |weight| @content.images.build(:weight => weight) }
      render action: "edit"
    end
  end

  def show
    @content = Content.find(params[:id])
    authorize! :read, @content

    # If we've accessed this content using the wrong path, edirect to canonical
    # url and exit early. We assume this redirection is permanent. All paths
    # beginning with /submission are are blocked to search robots.
    if (@content.hidden? && !params[:hidden]) || (params[:hidden] && !@content.hidden?)
      redirect_to content_path(@content)
      return
    end

    # Load empty comment for comment form
    @comment = Comment.new { |c| c.content = @content }

    # Load all visible comments, except for editors who see all by default.
    @comments = @content.comments.oldest
    @comments.visible unless current_user && current_user.editor?

    # Find related articles
    begin
      search = Sunspot.more_like_this(@content) do
        fields :title, :summary, :body
        minimum_term_frequency 1
        paginate :page => 1, :per_page => 4
      end
      @related_content =  search.results
    rescue Errno::ECONNREFUSED
      logger.error "Solr connection refused: unable to find related content."
      @related_content = []
    end
  end

  def destroy
    @content = Content.find(params[:id])
    authorize! :destroy, @content

    if @content.destroy
      redirect_to :root, :notice => "Your #{@type} has been deleted."
    else
      redirect_to :back, :notice => "An error occurred trying to delete your #{@type}"
    end
  end

  def moderate
    @content = Content.find(params[:id])
    authorize! :moderate, @content

    @content.status = params[:status]
    if @content.save
      redirect_to :back
    else
      redirect_to :back, :notice => "An error occurred moderating this content #{@content.errors.full_messages}"
    end
  end

  protected
  def content_type_key
    params[:type].downcase
  end

  def initialize_content_names
    if params[:type].present?
      @type = params[:type].downcase
    end
  end
end