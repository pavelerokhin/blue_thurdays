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
    @in_time = time_in.to_time
    @out_time ||= @in_time + rand(1..5)

    loop do
      break if @out_time.nil? || Time.now.to_time >= @out_time

      sleep 1 # Adjust the sleep duration as needed
    end

    out
  rescue => e
    puts "Error while parking: #{e.message}"
  end

  def out(out_time = Time.now)
    @state = :out
    @out_time = out_time

    # perform an async function that will remove the vehicle from the parking lot
    # it should sent to the Parking class the vehicle and the out_time

    Parking.exit_parking(self, out_time)
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
