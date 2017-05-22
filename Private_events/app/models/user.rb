class User < ApplicationRecord
  has_many :events,          :foreign_key => :creator_id # eventos
  has_many :attended_events, :through =>     :event_attendees #asistencias
  has_many :event_attendees, :foreign_key => :attendee_id #asistentes a cada evento
  
  def upcaming_events
    self.attended_events.upcaming
  end
  
  def previous_events
    self.attended_events.past
  end
    
  def attend(event)
    self.event_attendees.create(attended_event_id: event.id)
  end
  
  def cancel(event)
    self.event_attendees.find_by(attended_event_id: event.id).destroy
  end  
  
  def attending?(event)
    event.attendees.include?(self)
  end
end
