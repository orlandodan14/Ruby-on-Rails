Airport.delete_all
Airport.create!([
                {code: "SFO"},
                {code: "ATL"},
                {code: "JFK"},
                {code: "CCS"},
                {code: "ADD"},
                {code: "ADQ"},
                {code: "AET"},
                {code: "AGA"},
                {code: "ABE"}])
                
Flight.delete_all
Airport.all.each do |from_airport|
  Airport.all.each do |to_airport|
    unless from_airport == to_airport
      n = rand(1..5)
      n.times do |n|
        y = rand(1..20)
        Flight.create!(from: from_airport.id,
                       to: to_airport.id,
                       datetime: (Time.now + y.week),
                       duration: 60 * y )
      end      
    end    
  end
end