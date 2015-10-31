require 'rails_helper'

describe Flag do
  let(:flag) { build(:flag) }

  it { should belong_to :user }

  it { is_expected.to validate_presence_of :longitude }
  it { is_expected.to validate_presence_of :latitude }
  it { is_expected.to validate_presence_of :radius }
  it { is_expected.to validate_numericality_of :longitude }
  it { is_expected.to validate_numericality_of :latitude }
  it { is_expected.to validate_numericality_of :radius }

  describe '#params_for_wuinloc' do
    let(:expected_params) do
      { id: flag.id,
        longitude: flag.longitude,
        latitude: flag.latitude,
        radius: flag.radius }
    end

    subject { flag.params_for_wuinloc }

    it { is_expected.to eq expected_params }
  end
end
