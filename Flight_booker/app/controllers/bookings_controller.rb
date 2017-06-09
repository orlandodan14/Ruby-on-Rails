class BookingsController < ApplicationController
  def new
    flight = Flight.find(params[:flight][:flight_id])
    @booking = flight.bookings.build
    params[:num_tickets].to_i.times do
      @booking.passengers.build
    end
  end
  
  def create
    flight = Flight.find(params[:booking][:flight_id])
    @booking = flight.bookings.build(booking_params)
    if @booking.save
      send_emails(@booking.passengers)
      redirect_to @booking
    else
      render :new
    end
  end

  def show
    @booking = Booking.find(params[:id])
  end
  
   private

    def booking_params
      params.require(:booking).permit(passengers_attributes: [:name, :email])
    end
    
    def send_emails(passengers)
      passengers.each do |passenger|
        PassengerMailer.thank_you(passenger).deliver_now
      end
    end
end
