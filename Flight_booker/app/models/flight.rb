class Flight < ApplicationRecord
  belongs_to :from_airport, class_name: "Airport", foreign_key: "from", dependent: :destroy
  belongs_to :to_airport,   class_name: "Airport", foreign_key: "to",   dependent: :destroy
  has_many :bookings
  has_many :passengers, through: :bookings
end
