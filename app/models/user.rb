class User < ActiveRecord::Base
  has_many :vehicles
  accepts_nested_attributes_for :vehicles
  has_many :wuis

  validates_uniqueness_of :phone_number
  validates :phone_number, phone:  { possible: true, allow_blank: false, types: [:mobile] }

  def valid_verification_code?(code)
    verification_code == code
  end
end
