class CreateBoats < ActiveRecord::Migration
  def change
    create_table :boats do |t|
      t.string :name
      t.integer :capacity
      t.boolean :use, default: false

    end
  end
end
