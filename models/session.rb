class Session < ActiveRecord::Base
  has_many :pictures
  belongs_to :spot, foreign_key: 'spot_woo_id', primary_key: 'woo_id'

  validates :spot, presence: true
end
