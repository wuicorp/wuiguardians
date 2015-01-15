class User < ActiveRecord::Base
  has_many :wuis
  has_many :vehicles
  accepts_nested_attributes_for :vehicles

  validates_uniqueness_of :phone_number, scope: [:phone_prefix]
  validates :phone_number, phone:  { possible: true, allow_blank: false, types: [:mobile] }
  validates :phone_prefix, presence: true,
                           numericality: true,
                           length: { minimum: 1, maximum: 3 }

  def self.find_by_phone(prefix, number)
    find_by_phone_prefix_and_phone_number(prefix, number)
  end
end
