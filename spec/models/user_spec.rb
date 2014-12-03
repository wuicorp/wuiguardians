require 'rails_helper'

describe User do
  it { should have_many(:vehicles) }
  it { should have_many(:wuis) }
  it { should validate_presence_of(:phone_prefix) }
  it { should validate_numericality_of(:phone_prefix) }
  it { should accept_nested_attributes_for(:vehicles) }
end
