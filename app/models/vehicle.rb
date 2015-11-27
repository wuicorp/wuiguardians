class Vehicle < ActiveRecord::Base
  belongs_to :user
  has_many :wuis
  validates_presence_of :identifier

  def as_json(options = {})
    super({ only: [:id, :identifier] }.merge(options))
  end

  def identifier=(value)
    formated = value.present? ? value.to_s.gsub(/[^0-9A-Za-z]/, '').upcase : nil
    super(formated)
  end

  def owned_by?(user)
    self.user == user
  end
end
