class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.belongs_to :timeslot
      t.belongs_to :boat

      t.timestamps
    end
  end
end
