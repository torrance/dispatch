class FrontpageController < ApplicationController
  def show
    @primary_feature = Content.recent.has_image.featured.first
    @features = Content.recent.featured.where("id <> ?", @primary_feature.id).limit(7)
    @newswire = Content.recent.where("id <> ?", @primary_feature).
      where("id NOT IN (?)", @features.map(&:id)).page(params[:page]).per(25)
    @events = Event.upcoming

    respond_to do |format|
      format.html
      format.js
    end
  end
end
