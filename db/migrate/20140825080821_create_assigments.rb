class CreateAssigments < ActiveRecord::Migration
  def change
    create_table :assigments do |t|
      t.belongs_to :timeslot
      t.belongs_to :boat

      t.timestamps
    end
  end
end
