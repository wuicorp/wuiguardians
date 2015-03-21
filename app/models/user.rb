class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  #  :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :wuis
  has_and_belongs_to_many :vehicles
  accepts_nested_attributes_for :vehicles

  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner

  def developer?
    role.to_sym == :developer
  end

  def find_all_received_wuis
    Wui.where(vehicle_id: vehicles.map(&:id))
  end
end
