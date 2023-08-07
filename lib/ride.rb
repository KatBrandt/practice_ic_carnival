class Ride 
  attr_reader :name, 
              :min_height,
              :admission_fee,
              :excitement,
              :rider_log

  def initialize(info)
    @name = info[:name]
    @min_height = info[:min_height]
    @admission_fee = info[:admission_fee]
    @excitement = info[:excitement]
    @rider_log = Hash.new(0)
  end

  def board_rider(visitor)
    if visitor.preferences.include?(@excitement) && 
      visitor.tall_enough?(@min_height) && 
      visitor.spending_money >= @admission_fee
          @rider_log[visitor] += 1
          visitor.decrease_spending_money(@admission_fee)
          # visitor.spending_money -= @admission_fee 
    end
  end

  def total_revenue
    # number times riden * admission fee
    @rider_log.values.sum * @admission_fee
  end
end