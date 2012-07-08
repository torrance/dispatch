class FrontpageController < ApplicationController
  def show
    @primary_feature = Content.recent.has_image.featured.first
    @features = Content.recent.featured.where("id <> ?", @primary_feature.id).limit(6)
    @newswire = Content.recent.where("id <> ?", @primary_feature).
      where("id NOT IN (?)", @features.map(&:id))
    @events = Event.upcoming
  end
end
