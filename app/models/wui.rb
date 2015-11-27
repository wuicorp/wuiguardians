class Wui < ActiveRecord::Base 
  belongs_to :user
  has_and_belongs_to_many :users

  validates_presence_of :wui_type
  validates_presence_of :user
  validates_presence_of :vehicle_identifier, if: -> { latitude.blank? && longitude.blank? }
  validates_presence_of :latitude, :longitude, if: -> { vehicle_identifier.blank? }
  validates_inclusion_of :status, in: %w(sent received truthy falsey) << nil

  before_create -> { self.status = 'sent' }
  before_create :calculate_users

  def user_ids_at
    Flags.at(longitude, latitude).join(:users).distinct.pluck('user.id')
  end

  def owned_by?(user_to_check)
    user_to_check == user || vehicle_users.include?(user_to_check)
  end

  def calculate_users
    users << vehicle_users if vehicle_users.present?
    users << flag_users if flag_users.present?
    users
  end

  def vehicle_users
    return unless vehicle_identifier.present?
    @vehicle_users ||= Vehicle.where(identifier: vehicle_identifier).reduce([]) do |users, v|
      users << v.user
    end
  end

  def flag_users
    return unless longitude.present? && latitude.present?
    @flag_users ||=
      Flag.at(latitude: latitude, longitude: longitude).map(&:user)
  end
end
