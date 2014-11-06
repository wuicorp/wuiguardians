class Vehicle < ActiveRecord::Base
  belongs_to :user
  has_many :wuis
end
