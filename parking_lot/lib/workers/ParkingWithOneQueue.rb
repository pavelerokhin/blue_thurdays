require 'concurrent'

class ParkingWithOneQueue
  include Concurrent::Async

  def initialize(parking_lot)
    @parking_lot = parking_lot
  end

  def park_or_refuse(vehicle)
    @parking_lot.park_or_refuse(vehicle)
  end
end