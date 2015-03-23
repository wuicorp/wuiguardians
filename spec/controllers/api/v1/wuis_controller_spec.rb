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

  describe 'POST #create', authenticated_resource: true do
    let(:action) { -> { post :create, request_params } }

    context 'with valid parameters' do
      let(:vehicle) { create(:vehicle, users: [current_owner]) }

      let(:before_context) { vehicle }

      let(:request_params) do
        { wui_type: :crash, vehicle_identifier: vehicle.identifier }
      end

      context 'with successful pusher trigger' do
        let(:notification) { double(:notification) }

        let(:before_context) do
          allow(controller).to receive(:notification_for)
            .with(kind_of(Wui))
            .and_return(notification)

          expect(Pusher).to receive(:trigger)
            .with(current_owner.id.to_s, 'wui_create', notification)
        end

        it { is_expected.to respond_with(201) }

        it 'responds with right parameters' do
          expect(response_body).to include 'id'
          expect(response_body).to include 'wui_type'
          expect(response_body).to include 'status'
          expect(response_body).to include 'vehicle'
          expect(response_body['vehicle']).to include 'id'
          expect(response_body['vehicle']).to include 'identifier'
        end

        it 'creates the wui with :sent status' do
          expect(response_body['status']).to eq 'sent'
        end
      end

      context 'with failing pusher trigger' do
        let(:before_context) do
          expect(Pusher).to receive(:trigger).and_raise(Pusher::Error)
          expect(Rollbar).to receive(:error)
        end

        it { is_expected.to respond_with 500 }
        it 'does not create the wui' do
          expect(Wui.all.count).to eq 0
        end
      end
    end

    context 'with invalid parameters' do
      context 'with unexisting vehicle' do
        let(:request_params) do
          { wui_type: '', vehicle_identifier: 'unexiststing' }
        end

        it { is_expected.to respond_with(422) }
        it 'has validation errors' do
          expect(response_body['errors']).to include 'vehicle'
          expect(response_body['errors']).to include 'wui_type'
        end
      end
    end
  end
end
