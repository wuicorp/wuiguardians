require 'rails_helper'

describe Wui do
  it do
    is_expected.to validate_inclusion_of(:status)
      .in_array(%w(sent received truthy falsey) << nil)
  end

  it 'sets default status before create' do
    wui = build(:wui, status: nil).tap(&:save!)
    expect(wui.status).to eq 'sent'
  end

  describe '#calculate_users' do
    let(:vehicle) { create(:vehicle) }
    let(:user) do
      create(:user, vehicles: [vehicle])
    end

    subject do
      wui.calculate_users
    end

    context 'wui for a vehicle' do
      let(:wui) do
        build(:wui, vehicle_identifier: user.vehicles.last.identifier)
      end

      it { is_expected.to eq [user] }
    end

    context 'wui for a position' do
      let(:flag) { create(:flag, user: user) }

      let(:wui) do
        build(:wui, latitude: flag.latitude, longitude: flag.longitude)
      end

      it { is_expected.to eq [user] }
    end
  end
end
