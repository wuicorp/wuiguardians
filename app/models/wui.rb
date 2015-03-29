class Wui < ActiveRecord::Base 
  belongs_to :user
  belongs_to :vehicle

  validates_presence_of :wui_type
  validates_presence_of :user, :vehicle
  validates_inclusion_of :status, in: %w(sent received truthy falsey) << nil

  before_create -> { self.status = 'sent' }

  def as_json(options = {})
    super({ only: [:id, :wui_type, :status, :updated_at],
            include: [vehicle: { only: [:id, :identifier] }] }.merge(options))
  end

  def vehicle_users
    vehicle.users
  end
end
