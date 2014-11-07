require 'rails_helper'

describe Wui do
  it { should belong_to(:user) }
  it { should belong_to(:vehicle) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:vehicle) }
end
