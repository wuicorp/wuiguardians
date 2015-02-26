require 'rails_helper'

describe User do
  it { should have_and_belong_to_many(:vehicles) }
  it { should have_many(:wuis) }
  it { should accept_nested_attributes_for(:vehicles) }
end
