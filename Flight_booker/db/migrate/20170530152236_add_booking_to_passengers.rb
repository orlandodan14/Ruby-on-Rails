class AddBookingToPassengers < ActiveRecord::Migration[5.0]
  def change
    add_reference :passengers, :booking, foreign_key: true
  end
end
