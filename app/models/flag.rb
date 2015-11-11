class Flag < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :longitude, :latitude, :radius
  validates_numericality_of :longitude
  validates_numericality_of :latitude
  validates_numericality_of :radius

  def params_for_wuinloc
    { id: id,
      longitude: longitude,
      latitude: latitude,
      radius: radius }
  end

  def self.at(latitude: nil, longitude: nil)
    return [] unless latitude && longitude

    m_per_deg_lat = 111_132.954 - 559.822 * Math.cos(2 * latitude) + 1.175 * Math.cos(4 * latitude)
    m_per_deg_lon = 111_132.954 * Math.cos(latitude)

    where('sqrt(' \
          "power((longitude - #{longitude}) * #{m_per_deg_lon}, 2) + " \
          "power(((latitude - #{latitude}) * #{m_per_deg_lat}), 2)" \
          ') < radius')
  end
end
