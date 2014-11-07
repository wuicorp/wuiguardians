class Wui < ActiveRecord::Base 
  belongs_to :user
  belongs_to :vehicle

  validates_presence_of :user, :vehicle

  def vehicle_user
    vehicle.user
  end
end
