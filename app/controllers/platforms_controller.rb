class PlatformsController < ApplicationController
  include CurrentUserConcern

  # GET /platforms
  def index
    @platforms = Platform.all
    render json: @platforms, each_serializer: PlatformSerializer
  end
end
