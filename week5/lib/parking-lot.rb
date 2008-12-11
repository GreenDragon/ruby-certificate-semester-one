require 'Time'

class ParkingLot
  
  # Must be able to:
  #
  # * Open close gate/bar thingy
  # * Take money for parking spot #
  # * Know how long the car can be there and mark it for fine if past time
  
  # has many spots
  @@spots = {}

  @@fines = {}
  
  # constants
  
  @@CAPACITY = 4
  
  @@RATE = 10
  
  @@MAX_TIME = 8 
  
  @@FINE = 100
  
  # attr_accessor :plate, :spot, :time_in, :time_out, :cost, :fine
  
  def initialize
    @@spots = {}
    @@fines = {}
  end
  
  def enter_lot?(plate, time_in)
    if @@spots.length == @@CAPACITY
      "Sorry! Lot is Full"
    else
      @@spots[plate] = Time.parse(time_in)
      [ "#{plate}", "#{@@spots[plate]}" ]
    end
  end
  
  def exit_lot_fee?(plate, time_out)
    if @@spots.key?(plate) then
      # "%.2f" % result ... = madness 
      ((( Time.parse(time_out) - @@spots[plate] )/3600 ) * @@RATE).to_int
    else
      "How did you sneak in?"
    end
  end
  
  def pay_fee(plate, fee, time_out)
    if @@spots.key?(plate) then
      cost = self.exit_lot_fee?(plate, time_out)
      [ "#{plate}", "OK", (fee - cost) ]
    else
      "Ticket Lost! No soup for you"
    end
  end
  
  def write_tickets
    @@spots.each_pair do |plate, time_in|
      if ( Time.parse("now") - time_in ) > @@MAX_TIME
        @@fines[plate] = @@FINE
      end
    end
    @@fines
  end
  
end
