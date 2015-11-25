require 'rails_helper'

describe Vehicle do
  describe '#identifier=' do
    context 'with value present' do
      subject { build(:vehicle, identifier: '1234-cmz') }
      its(:identifier) { is_expected.to eq '1234CMZ' }
    end

    context 'with nil value' do
      subject { build(:vehicle, identifier: nil) }
      its(:identifier) { is_expected.to be_nil }
    end
  end
end
