class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.belongs_to :timeslot
      t.integer :size

      t.timestamps
    end
  end
end
