require 'rails_helper'

describe Wui do
  it { should belong_to(:user) }
  it { should belong_to(:vehicle) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:vehicle) }
  it { should validate_presence_of(:wui_type) }

  it do
    is_expected.to validate_inclusion_of(:status)
      .in_array(%w(sent received truthy falsey) << nil)
  end

  it 'sets default status before create' do
    wui = build(:wui, status: nil).tap { |w| w.save }
    expect(wui.status).to eq 'sent'
  end
end
