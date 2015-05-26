class Flag < ActiveRecord::Base
  include Wuinloc::Support

  belongs_to :user

  validates_presence_of :longitude, :latitude, :radius
  validates_numericality_of :longitude
  validates_numericality_of :latitude
  validates_numericality_of :radius

  after_save :add_to_wuinloc

  def add_to_wuinloc
    wuinloc_service.save_flag(params_for_wuinloc)
  end

  def params_for_wuinloc
    { id: id,
      longitude: longitude,
      latitude: latitude,
      radius: radius }
  end
end
