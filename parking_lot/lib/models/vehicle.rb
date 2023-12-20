# frozen_string_literal: true


require '../enums/vehicle_state.rb'

class Vehicle
  attr_accessor :state, :type, :time_in, :time_out, :parking_place

  def in_queue(type)
    validate_type(type)
    @state = VehicleState::IN_QUEUE
    @time_in = nil
    @time_out = nil
    @type = type
  end

  def park(parking_place, time_in = Time.now)
    @parking_place = parking_place
    @state = VehicleState::PARKED
    @time_in = time_in
    @time_out = time_in + rand(1..5) # it will go out in 1-5 seconds
  end

  def finish(time_out = Time.now)
    @state = VehicleState::OUT
    @time_out = time_out
  end

  def get_parking_time
    return unless @time_out && @time_in

    if @time_out.is_a?(Time) && @time_in.is_a?(Time)
      @time_out - @time_in # in seconds
    else
      puts "Error: @time_out and @time_in must be Time objects."
      nil
    end
  end

  private

  def validate_type(type)
    valid_types = VehicleType.constants.map { |c| VehicleType.const_get(c) }
    unless valid_types.include?(type)
      raise ArgumentError, "Invalid vehicle type: #{type}"
    end
  end
end

def random_type_vehicle
  # Generate a random car type
  type = [VehicleType::MOTO, VehicleType::CAR, VehicleType::BUS].sample

  # Create a car with the random type and add it to the array
  Vehicle.new.in_queue(type)
end