class FlightsController < ApplicationController
  
  def index
    @airports = Airport.all.map { |airport| [airport.code, airport.id] }
    dates = Flight.all.map { |flight| flight.datetime.strftime("%Y-%m-%d") }
    @flight_dates = dates.uniq.sort_by { |d| d.split(?/).rotate(-1).map { |e| -e.to_i } }
    @passengers = [1, 2, 3, 4]
    
    @from = params[:from_code]
    @to = params[:to_code]
    @date = params[:date]
    @tickets = params[:num_tickets]
    
    @flights = Flight.where(from: @from, to: @to, datetime: @date)
  end
end
