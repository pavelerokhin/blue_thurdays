# frozen_string_literal: true


class Vehicle
  attr_accessor :state, :time_in, :time_out, :parking_place

  def in_queue
    @state = :in_queue
    @in_time = nil
    @out_time = nil
  end

  def park(parking_place, time_in = Time.now)
    @parking_place = parking_place
    @state = :parked
    @in_time = time_in
    @out_time = time_in + rand(1..5) # it will go out in 1-5 seconds
  end

  def out(out_time = Time.now)
    @state = :out
    @out_time = out_time
  end

  def pay
    time = get_parking_time
    if time
      time * @price
    end
  end

  def get_parking_time
    return unless @out_time && @in_time

    if @time_out.is_a?(Time) && @in_time.is_a?(Time)
      @out_time - @in_time # in seconds
    else
      puts "Error: @time_out and @in_time must be Time objects."
      nil
    end
  end
end

class Moto < Vehicle
  def initialize
    @type = :moto
    @size = 1
    @price = 1
  end
end

class Auto < Vehicle
    def initialize
      @type = :auto
      @size = 4
      @price = 2
  end
end

class Bus < Vehicle
  def initialize
    @type = :auto
    @size = 8
    @price = 4
  end
end

def random_type_vehicle
  type = [:moto, :auto, :bus].sample

  case type
  when :moto
    Moto.new
  when :auto
    Auto.new
  when :bus
    Bus.new
  else
    raise ArgumentError, "Invalid vehicle type: #{type}"
  end
end
