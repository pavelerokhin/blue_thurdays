# frozen_string_literal: true

class ParkingReceipt
  attr_accessor :parking_place, :parking_hours, :price, :in_time, :out_time

  def how_much_to_pay
    parking_hours * price
  end
end
