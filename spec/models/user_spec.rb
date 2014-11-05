require 'rails_helper'

describe User do
  it { should have_many(:vehicles) }

  it do
    should have_many(:own_wuis).class_name('Wui')
      .with_foreign_key(:owner_id)
  end

  it do
    should have_many(:received_wuis).class_name('Wui')
      .with_foreign_key(:receiver_id)
  end

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_confirmation_of(:password) }
  it { should accept_nested_attributes_for(:vehicles) }
end
