class Api::V1::EventsController < ApplicationController
  before_action :set_event, except: [:create]
  
  def show
    render json: @event
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end
end
