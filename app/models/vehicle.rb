class Vehicle < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :wuis
  validates_presence_of :identifier
  validates_uniqueness_of :identifier

  def as_json(options = {})
    super({ only: [:id, :identifier] }.merge(options))
  end

  def belongs_to?(user)
    users.include?(user)
  end

  def just_belongs_to?(user)
    belongs_to?(user) && users.count == 1
  end

  def identifier=(value)
    formated = value.present? ? value.to_s.gsub(/[^0-9A-Za-z]/, '').upcase : nil
    super(formated)
  end

  def owned_by?(user)
    users.include?(user)
  end
end
