class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string     :picture_type
      t.string     :url
      t.belongs_to :session
      t.timestamps
    end
  end
end
