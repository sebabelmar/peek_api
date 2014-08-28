class Scheduler

  # Timeslot Controller Helpers
  def self.delete_timestaps(object)
    object.attributes.delete_if{|k, v| k == "created_at" || k == "updated_at"}
  end

  def self.register_overlaping
    timeslots = Timeslot.all
    timeslots.each do |timeslot|
      init = timeslot.start_time
      timeslots.each do |timeslot_to_compare|
        start_time = timeslot_to_compare.start_time
        finish_time = timeslot_to_compare.start_time + (timeslot_to_compare.duration * 60)

        if (start_time..finish_time).include?(init) && timeslot_to_compare.id != timeslot.id
          timeslot.overlap = timeslot_to_compare.id
          timeslot_to_compare.overlap = timeslot.id
          timeslot.save
          timeslot_to_compare.save
        end
      end
    end
  end

  # Assignment Controller Helpers
  def self.update_boat_use(timeslot_id, boat_id)
    timeslot = Timeslot.find(timeslot_id)

      boat = Boat.find(boat_id)
      boat.use = false
      boat.save
  end

  def self.update_availability(timeslot_id)
    timeslot = Timeslot.find(timeslot_id)

    if timeslot.bookings.size > 0
      seats_in_use = timeslot.bookings.map(&:size).reduce(:+)
    else
      seats_in_use = 0
    end

    if timeslot.boats.map(&:use).include?(true)
      timeslot.availability =  timeslot.boats.where(use: false).map(&:capacity).reduce(:+)
      timeslot.save
    else
      timeslot.availability = timeslot.boats.map(&:capacity).reduce(:+) - seats_in_use
      timeslot.save
    end
  end


  # Booking Controller Helpers
  def self.update_availability_booking(timeslot_id)
    timeslot = Timeslot.find(timeslot_id)

    if timeslot.bookings.size > 0
      seats_in_use = timeslot.bookings.map(&:size).reduce(:+)
      timeslot.customer_count = seats_in_use
      timeslot.save
    else
      seats_in_use = 0
    end

    if timeslot.boats.map(&:use).include?(true)
      timeslot.availability =  timeslot.boats.where(use: false).map(&:capacity).reduce(:+)
      timeslot.save
    else
      timeslot.availability = timeslot.boats.map(&:capacity).reduce(:+) - seats_in_use
      timeslot.save
    end
  end

  def self.use_a_boat(booking_size, timeslot_id)
    capacity_available = {}

    timeslot = Timeslot.find(timeslot_id)

    # refactor this using each with object or an other enumerable
    timeslot.boats.each do |boat|
      capacity_available[boat.id] = boat.capacity
    end

    if timeslot.boats.size > 1
      capacity_available.each do |boat_id, capacity|
        if booking_size <= capacity && booking_size > (capacity / 2)
          boat = Boat.find(boat_id)
          boat.use = true
          boat.save
        end
      end
    end
  end

  def self.delete_overlap_assignments(id)
      timeslot = Timeslot.find(id)
      assignment_to_check = Assignment.find_by_timeslot_id(id)
      assignment_to_delete = Assignment.find_by_timeslot_id(timeslot.overlap)

      if timeslot.overlap != 0 && assignment_to_delete.boat_id  == assignment_to_check.boat_id
        assignment_to_delete.destroy!
        timeslot_overlap = Timeslot.find(timeslot.overlap)
        timeslot_overlap.availability = 0
        timeslot_overlap.save
      end
  end
end
