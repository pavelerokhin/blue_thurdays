# frozen_string_literal: true

class Queue
  def initialize
    @queue = []
  end

  # Enqueue: Add an element to the end of the queue
  def enqueue(element)
    @queue.push(element)
  end

  def enqueue_random_vehicle
    # Generate a random car type
    type = [VehicleType::MOTO, VehicleType::CAR, VehicleType::BUS].sample

    # Create a car with the random type and add it to the array
    @queue.enqueue(Vehicle.new.in_queue(type))
  end

  # Dequeue: Remove and return the element from the front of the queue
  def dequeue
    @queue.shift
  end

  # Check if the queue is empty
  def empty?
    @queue.empty?
  end
end
