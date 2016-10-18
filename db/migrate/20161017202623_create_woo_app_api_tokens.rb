class CreateWooAppApiTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :woo_app_api_tokens do |t|
      t.string :access_token
      t.datetime :expires_at
      t.string :scope
      t.string :refresh_token

      t.timestamps null: false
    end
  end
end

