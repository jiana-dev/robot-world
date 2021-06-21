class CreateCarParts < ActiveRecord::Migration[5.2]
  def change
    create_table :car_parts do |t|
      t.references :car, foreign_key: true
      t.string :name
      t.integer :cost_price
      t.boolean :defective

      t.timestamps
    end
  end
end
