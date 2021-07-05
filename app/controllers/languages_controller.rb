class LanguagesController < ApplicationController
  include CurrentUserConcern

  # GET /languages
  def index
    @languages = Language.all
    render json: @languages, each_serializer: LanguageSerializer
  end
end
