class Vehicle < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :wuis
  validates :identifier, presence: true

  def as_json(options = {})
    super({ only: [:id, :identifier] }.merge(options))
  end

  def belongs_to?(user)
    users.include?(user)
  end

  def just_belongs_to?(user)
    belongs_to?(user) && users.count == 1
  end
end
