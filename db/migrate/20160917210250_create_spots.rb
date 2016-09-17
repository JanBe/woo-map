class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.string :woo_id
      t.string :name
      t.decimal :location_lat, precision: 10, scale: 6
      t.decimal :location_lng, precision: 10, scale: 6
      t.timestamps
    end
  end
end
