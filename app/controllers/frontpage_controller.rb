class FrontpageController < ApplicationController
  def show
    @primary_feature = Content.recent.has_image.featured.visible.first
    @features = Content.recent.featured.visible.where("id <> ?", @primary_feature.id).limit(3)
    @subfeatures = Content.recent.featurish.visible.where("id <> ?", @primary_feature).
      where("id NOT IN (?)", @features.map(&:id)).limit(4)
    @newswire = Content.recent.where("id <> ?", @primary_feature).
      where("id NOT IN (?)", @subfeatures.map(&:id)).
      where("id NOT IN (?)", @features.map(&:id)).
      visible.page(params[:page]).per(25)
    @events = Event.upcoming.visible.limit(15)

    respond_to do |format|
      format.html
      format.js
    end
  end
end
