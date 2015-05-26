require 'rails_helper'

describe User do
  it { should have_many(:wuis) }
  it { should have_and_belong_to_many(:vehicles) }
  it { should accept_nested_attributes_for(:vehicles) }
  it { should have_many(:flags) }

  describe '#developer?' do
    subject { build(:user, role: 'developer').developer? }
    it { is_expected.to be true }
  end

  describe '#find_all_received_wuis' do
    let(:wui) { create(:wui) }
    let(:user) { create(:user, vehicles: [wui.vehicle]) }

    subject { user.find_all_received_wuis.first }

    it { is_expected.to eq wui }
  end
end
