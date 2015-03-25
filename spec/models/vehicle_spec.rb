require 'rails_helper'

describe Vehicle do
  it { is_expected.to have_and_belong_to_many(:users) }
  it { is_expected.to have_many :wuis }
  it { is_expected.to validate_presence_of :identifier }

  describe '#belongs_to?' do
    let(:user) { create(:user) }
    let(:vehicle) { create(:vehicle) }

    subject { vehicle.belongs_to?(user) }

    context 'with user in users association' do
      before do
        vehicle.users << user
        vehicle.save!
      end
      it { is_expected.to be true }
    end

    context 'without user in users association' do
      it { is_expected.to be false }
    end
  end
end
