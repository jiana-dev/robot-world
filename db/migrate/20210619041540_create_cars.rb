class CreateCars < ActiveRecord::Migration[5.2]
  def change
    create_table :cars do |t|
      t.integer :year
      t.string :model
      t.string :state

      t.timestamps
    end
  end
end
