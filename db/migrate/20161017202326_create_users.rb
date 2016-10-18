class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :woo_id
      t.string :first_name
      t.string :last_name
      t.string :profile_picture_url
      t.string :cover_picture_url

      t.timestamps
    end
  end
end
