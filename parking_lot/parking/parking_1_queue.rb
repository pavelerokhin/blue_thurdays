# frozen_string_literal: true

require_relative './models/parking'
require_relative './models/vehicle'
require_relative './utils'


class Parking1Queue
  def initialize(levels=3,
                 rows_in_level=4,
                 places_in_row=10,
                 queue_max_size = 10,
                 outside_world_distribution = [0.1..1.5],
                 parking_distribution = [1.0..2.5])
    @max_queue_size = queue_max_size
    @outside_world_distribution = outside_world_distribution
    @parking_distribution = parking_distribution

    @parking = Parking.new(levels, rows_in_level, places_in_row)
    @queue = Queue.new

    @mutex = Mutex.new
    @logger = Logger.new(STDOUT)

    @logger.info("#{GREEN}parking with one queue is ready#{RESET}")
  end

  def run
    loop do
      # vehicles coming from the outside world and enter the queue
      vehicle = if @queue.size < @max_queue_size
        vehicle = random_type_vehicle(@parking_distribution)
        @queue.push(vehicle)
        @logger.info("#{vehicle.type} from the outside world is in the queue (size: #{@queue.size})")
        @queue.pop
      else
        @logger.info("#{RED}QUEUE IS FULL. No more vehicles from the outside world are allowed.#{RESET}")
        break
      end

      refused = @parking.park_or_refuse(vehicle)

      unless refused.nil?
        @queue.push(refused)
        @logger.info("#{refused.type} has been refused and pushed is in the queue (size: #{@queue.size})") if @queue.size > 1
      end

      @logger.info("#{RED}quit simulation with Q pressed#{RESET}") && break if quit?

      sleep rand(*@outside_world_distribution)
    end

    display_statistics
  end

  def snapshot
    @mutex.synchronize do
      return {
        'parking_space': @parking.parking_space,
        'queue': @queue.size,
        'money': @parking.money,
        'out_times': @parking.out_times
      }
    end
  end

  private

  def display_statistics
    @logger.info("#{LIGHT_YELLOW}Total money: #{@parking.money}")
    @logger.info("# vehicles served: #{@parking.out_times.length}#{RESET}")
  end
end
