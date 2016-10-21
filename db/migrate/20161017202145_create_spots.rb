class CreateSpots < ActiveRecord::Migration[5.0]
  def change
    create_table :spots do |t|
      t.string :woo_id
      t.string :name
      t.decimal :location_lat
      t.decimal :location_lng

      t.timestamps
    end
  end
end
