class Spot < ActiveRecord::Base
  has_many :sessions
end
