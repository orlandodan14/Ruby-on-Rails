model Airpot code:string
	has_many :departing_flights, class_name: "Flight"
  has_many :arriving_flights,  class_name: "Flight"

model Flight from:integer to:integer datetime:datetime duration:integer
	belongs_to :from_airport, class_name: "Airport", foreign_key: "from", dependent: :destroy
  belongs_to :to_airport,   class_name: "Airport", foreign_key: "to",   dependent: :destroy