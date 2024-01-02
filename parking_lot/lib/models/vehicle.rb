# frozen_string_literal: true

require 'securerandom'


class Vehicle
  attr_accessor :cashier
  attr_reader  :parking_place, :id, :type, :size, :price

  def initialize
    @id ||= SecureRandom.uuid
    @state = :in_queue
    @parking_place = nil

    @logger ||= Logger.new(STDOUT)
  end

  def in_queue
    @state = :in_queue
    @parking_hours = nil
  end

  def park(parking_place, parking_hours = rand(2..14), in_time = Time.now)
    @parking_place = parking_place
    @state = :parked
    @time_in = in_time
    @parking_hours = parking_hours

    Thread.new do
      sleep @parking_hours
      pay_and_exit
    end
  end

  def pay_and_exit(time_out = Time.now)
    @state = :out
    @time_out = time_out
    @cashier.pay_and_exit(self, time_out)
  end

  def pay
    @parking_hours * @price
  end

  private

  def get_parking_time
    return unless @parking_hours && @time_in

    if @parking_hours.is_a?(Time) && @time_in.is_a?(Time)
      @parking_hours - @time_out # in seconds
    else
      logger.error("Error: @time_out and @in_time must be Time objects")
    end
  end
end

class Moto < Vehicle
  def initialize
    super
    @type = :moto
    @size = 1
    @price = 1
  end
end

class Auto < Vehicle
    def initialize
      super
      @type = :auto
      @size = 4
      @price = 2
  end
end

class Bus < Vehicle
  def initialize
    super
    @type = :auto
    @size = 8
    @price = 4
  end
end

def random_type_vehicle
  [Moto, Auto, Bus].sample.new
end

