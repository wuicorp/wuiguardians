class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable

  has_many :vehicles
  accepts_nested_attributes_for :vehicles

  has_many :own_wuis, class_name: 'Wui', foreign_key: :owner_id
  has_many :received_wuis, class_name: 'Wui', foreign_key: :receiver_id

  validates_presence_of :password_confirmation, if: :password_required?
end
