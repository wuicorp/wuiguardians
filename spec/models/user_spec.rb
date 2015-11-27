require 'rails_helper'

describe User do
  describe '#developer?' do
    subject { build(:user, role: 'developer').developer? }
    it { is_expected.to be true }
  end
end
