class EventAttendeesController < ApplicationController  
  
  def create
    @event = Event.find(params[:event_attendee][:attended_event_id])
    current_user.attend(@event)
    redirect_to @event
  end
  
  def destroy
    @event = Event.find(params[:id])
    current_user.cancel(@event)
    redirect_to @event
  end
end
