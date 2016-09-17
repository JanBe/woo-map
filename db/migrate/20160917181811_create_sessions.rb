class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :woo_id
      t.float :max_airtime
      t.float :highest_jump
      t.float :total_height
      t.float :total_airtime
      t.integer :duration
      t.integer :number_of_jumps
      t.string :description
      t.float :max_crash_power
      t.string :user_name
      t.integer :spot_id
      t.integer :likes
      t.integer :comments
      t.datetime :posted_at
      t.datetime :finished_at
      t.string :title
      t.string :spot_woo_id
      t.timestamps
    end
  end
end
