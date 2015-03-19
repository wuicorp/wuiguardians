require 'rails_helper'

describe Api::V1::WuisController do
  it { is_expected.to be_a_kind_of Api::V1::ApiController }

  describe 'GET #index', authenticated_resource: true do
    let(:action) { -> { get :index } }

    it { is_expected.to respond_with 200 }

    context 'without existing wuis' do
      it 'responds with empty list' do
        expect(response_body).to eq []
      end
    end

    context 'with sent and received wuis' do
      let(:received_wui) do
        sender = create(:user)
        vehicle = build(:vehicle)
        vehicle.users << current_owner
        create(:wui,
               user: sender,
               vehicle: vehicle,
               updated_at: 2.minutes.ago)
      end

      let(:sent_wui) do
        receiver = create(:user)
        vehicle = build(:vehicle)
        vehicle.users << receiver
        create(:wui,
               user: current_owner,
               vehicle: vehicle,
               updated_at: 1.minute.ago)
      end

      let(:before_context) do
        received_wui
        sent_wui
      end

      it 'responds with wuis list' do
        expect(response_body.count).to eq 2
        expect(response_body.last['id']).to eq received_wui.id
        expect(response_body.first['id']).to eq sent_wui.id
      end

      it 'includes the expected attributes in the response' do
        expect(response_body.last).to include 'id'
        expect(response_body.last).to include 'wui_type'
        expect(response_body.last).to include 'action'
        expect(response_body.last).to include 'status'
        expect(response_body.last).to include 'updated_at'
        expect(response_body.last).to include 'vehicle'
        expect(response_body.last['vehicle']).to include 'id'
        expect(response_body.last['vehicle']).to include 'identifier'
      end

      it 'includes the right action in the response' do
        expect(response_body.last['action']).to eq 'received'
        expect(response_body.first['action']).to eq 'sent'
      end

      it 'includes the right vehicle in the response' do
        expect(response_body.last).to include 'vehicle'
        expect(response_body.last['vehicle']['id']).to eq current_owner
          .vehicles.first.id
      end
    end
  end
end
