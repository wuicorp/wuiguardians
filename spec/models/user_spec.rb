require 'rails_helper'

describe User do
  it { should have_many(:vehicles) }
  it { should have_many(:wuis) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_confirmation_of(:password) }
  it { should accept_nested_attributes_for(:vehicles) }
end
