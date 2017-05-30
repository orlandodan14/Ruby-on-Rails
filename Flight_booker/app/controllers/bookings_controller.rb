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
end
