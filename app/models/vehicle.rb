class Vehicle < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :wuis
  validates :identifier, presence: true
end
