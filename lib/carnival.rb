class Carnival 
  attr_reader :duration, :rides

  def initialize(duration)
    @duration = duration
    @rides = []
  end

  def add_ride(ride)
    @rides << ride 
  end

  def most_popular_ride
    max_number = 0
    max_ride = nil

    @rides.each do |ride|
      if ride.rider_log.values.sum > max_number 
        max_number = ride.rider_log.values.sum
        max_ride = ride
      end
    end

    max_ride
  end

  def most_profitable_ride
    @rides.max_by do |ride|
      ride.total_revenue
    end
  end
end