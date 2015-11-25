class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  #  :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :sent_wuis, class_name: 'Wui'
  has_and_belongs_to_many :received_wuis, class_name: 'Wui'
  has_many :flags
  has_many :vehicles
  accepts_nested_attributes_for :vehicles

  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner

  def developer?
    role.to_sym == :developer
  end
end
