class User < ActiveRecord::Base
  has_many :vehicles
  accepts_nested_attributes_for :vehicles
  has_many :wuis

  validates_presence_of :phone_number

  def valid_verification_code?(code)
    verification_code == code
  end
end
