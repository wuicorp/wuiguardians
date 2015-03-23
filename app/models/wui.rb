class Wui < ActiveRecord::Base 
  belongs_to :user
  belongs_to :vehicle

  validates_presence_of :wui_type
  validates_presence_of :user, :vehicle

  before_create -> { self.status = :sent }

  def vehicle_user
    vehicle.user
  end

  def as_json(options = {})
    super({ only: [:id, :wui_type, :status, :updated_at],
            include: [:vehicle] }.merge(options))
  end
end
