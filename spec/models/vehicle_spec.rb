require 'rails_helper'

describe Vehicle do
  it { is_expected.to have_and_belong_to_many(:users) }
  it { is_expected.to have_many :wuis }
  it { is_expected.to validate_presence_of :identifier }
end
