class EventsController < ApplicationController
  def index
    @events = Event.published.upcoming
  end

  def show
    @event = Event.published.find_by!(slug: params[:slug])
    @rsvp = current_user&.event_rsvps&.find_by(event: @event)
  end
end
