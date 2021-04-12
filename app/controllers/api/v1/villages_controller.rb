class Api::V1::VillagesController < ApplicationController
  def index
    @villages = Village.search(params)
    render json: @villages
  end
end
