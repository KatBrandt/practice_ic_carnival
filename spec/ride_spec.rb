require "rspec"
require "./lib/visitor"
require "./lib/ride"

RSpec.describe Ride do 
  it "exists" do 
    ride1 = Ride.new({ 
          name: 'Carousel', 
          min_height: 24, 
          admission_fee: 1, 
          excitement: :gentle 
        })
    expect(ride1).to be_a Ride
  end 

  it "has attributes" do 
    ride1 = Ride.new({ 
          name: 'Carousel', 
          min_height: 24, 
          admission_fee: 1, 
          excitement: :gentle 
        })
    
    expect(ride1.name).to eq("Carousel")
    expect(ride1.min_height).to eq(24)
    expect(ride1.admission_fee).to eq(1)
    expect(ride1.excitement).to eq(:gentle)
  end

  describe "#board_rider" do 
    it "has a rider log" do 
      ride1 = Ride.new({ name: 'Carousel', min_height: 24, admission_fee: 1, excitement: :gentle })
      
      visitor1 = Visitor.new('Bruce', 54, '$10')
      visitor2 = Visitor.new('Tucker', 36, '$5')

      visitor1.add_preference(:gentle)
      visitor2.add_preference(:gentle)

      expect(ride1.rider_log).to eq({})

      ride1.board_rider(visitor1)
      ride1.board_rider(visitor2)
      ride1.board_rider(visitor1)

      expected = {
        visitor1 => 2,
        visitor2 => 1
      }

      expect(ride1.rider_log).to eq(expected)
    end

    it "reduces riders spending money" do 
      ride1 = Ride.new({ name: 'Carousel', min_height: 24, admission_fee: 1, excitement: :gentle })
      
      visitor1 = Visitor.new('Bruce', 54, '$10')
      visitor2 = Visitor.new('Tucker', 36, '$5')

      visitor1.add_preference(:gentle)
      visitor2.add_preference(:gentle)

      ride1.board_rider(visitor1)
      ride1.board_rider(visitor2)
      ride1.board_rider(visitor1)

      expect(visitor1.spending_money).to eq 8
      expect(visitor2.spending_money).to eq 4
    end

    it "only boards with certain conditions" do 
      ride1 = Ride.new({ name: 'Carousel', min_height: 24, admission_fee: 1, excitement: :gentle })
      ride2 = Ride.new({ name: 'Ferris Wheel', min_height: 36, admission_fee: 5, excitement: :gentle })
      ride3 = Ride.new({ name: 'Roller Coaster', min_height: 54, admission_fee: 2, excitement: :thrilling })

      visitor1 = Visitor.new('Bruce', 54, '$10')
      visitor2 = Visitor.new('Tucker', 36, '$5')
      visitor3 = Visitor.new('Penny', 64, '$15')

      visitor1.add_preference(:gentle)
      visitor2.add_preference(:gentle)
      visitor2.add_preference(:thrilling)
      visitor3.add_preference(:thrilling)

      ride1.board_rider(visitor1)
      ride1.board_rider(visitor2)
      ride1.board_rider(visitor1)

      ride2.board_rider(visitor2)
      ride2.board_rider(visitor1)

      ride3.board_rider(visitor1)
      ride3.board_rider(visitor2)
      ride3.board_rider(visitor3)

      expect(visitor1.spending_money).to eq 3
      expect(visitor2.spending_money).to eq 4
      expect(visitor3.spending_money).to eq 13

      ride1_expected = {
        visitor1 => 2,
        visitor2 => 1
      }

      ride2_expected = {
        visitor1 => 1
      }

      ride3_expected = {
        visitor3 => 1
      }

      expect(ride1.rider_log).to eq(ride1_expected)
      expect(ride2.rider_log).to eq(ride2_expected)
      expect(ride3.rider_log).to eq(ride3_expected)
    end
  end

  it "calculates total revenue" do 
    ride1 = Ride.new({ name: 'Carousel', min_height: 24, admission_fee: 1, excitement: :gentle })
    ride2 = Ride.new({ name: 'Ferris Wheel', min_height: 36, admission_fee: 5, excitement: :gentle })
    ride3 = Ride.new({ name: 'Roller Coaster', min_height: 54, admission_fee: 2, excitement: :thrilling })

    visitor1 = Visitor.new('Bruce', 54, '$10')
    visitor2 = Visitor.new('Tucker', 36, '$5')
    visitor3 = Visitor.new('Penny', 64, '$15')

    visitor1.add_preference(:gentle)
    visitor2.add_preference(:gentle)
    visitor2.add_preference(:thrilling)
    visitor3.add_preference(:thrilling)

    ride1.board_rider(visitor1)
    ride1.board_rider(visitor2)
    ride1.board_rider(visitor1)

    ride2.board_rider(visitor2)
    ride2.board_rider(visitor1)

    ride3.board_rider(visitor1)
    ride3.board_rider(visitor2)
    ride3.board_rider(visitor3)

    expect(ride1.total_revenue).to eq 3
    expect(ride2.total_revenue).to eq 5
    expect(ride3.total_revenue).to eq 2
  end
end