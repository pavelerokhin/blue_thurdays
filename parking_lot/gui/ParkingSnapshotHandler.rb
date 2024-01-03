# frozen_string_literal: true

class ParkingSnapshotHandler
  def initialize(parking)
    @parking = parking
  end
  def get_snapshot
    @parking.snapshot
  end
end