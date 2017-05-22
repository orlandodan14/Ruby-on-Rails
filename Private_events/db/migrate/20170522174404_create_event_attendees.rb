class CreateEventAttendees < ActiveRecord::Migration[5.0]
  def change
    create_table :event_attendees do |t|
      t.integer :attendee_id
      t.integer :attended_event_id

      t.timestamps
    end
    add_index :event_attendees, [:attendee_id, :attended_event_id]
  end
end
