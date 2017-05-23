class Event < ApplicationRecord
  scope :upcoming, -> { where("Date >= ?", Date.today).order('Date ASC') }
  scope :past,     -> { where("Date <  ?", Date.today).order('Date DESC') }
  
  belongs_to :creator,       :class_name =>  "User" 
  
  has_many :attendees,       :through =>     :event_attendees # asistentes
  has_many :event_attendees, :foreign_key => :attended_event_id # asistentes a cada evento
    
  def upcaming
    @upcoming_events = current_user.upcoming_events
  end
  
  def past
    @prev_events = current_user.previous_events
  end
  
end
