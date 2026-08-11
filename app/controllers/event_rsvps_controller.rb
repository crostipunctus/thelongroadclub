class EventRsvpsController < ApplicationController
  before_action :require_authentication
  before_action :set_event

  def create
    rsvp = current_user.event_rsvps.find_or_initialize_by(event: @event)
    rsvp.status = params[:status].presence_in(EventRsvp.statuses.keys) || "going"
    if rsvp.save
      redirect_to @event, notice: "Your RSVP is saved."
    else
      redirect_to @event, alert: rsvp.errors.full_messages.to_sentence
    end
  end

  def destroy
    current_user.event_rsvps.find_by(event: @event)&.destroy
    redirect_to @event, notice: "Your RSVP was cancelled."
  end

  private

  def set_event
    @event = Event.published.find_by!(slug: params[:event_slug])
  end
end
