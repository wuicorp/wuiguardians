class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  #  :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :wuis
  has_many :vehicles
  accepts_nested_attributes_for :vehicles

  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner

  def developer?
    role == 'developer'
  end
end
