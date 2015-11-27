require 'rails_helper'

describe Api::V1::WuisController do
  it { is_expected.to be_a_kind_of Api::V1::ApiController }

  describe 'GET #sent', authenticated_resource: true do
    it_behaves_like 'get sent or received wuis', :sent
  end

  describe 'GET #received', authenticated_resource: true do
    it_behaves_like 'get sent or received wuis', :received
  end

  describe 'POST #create', authenticated_resource: true do
    let(:action) { -> { post :create, request_params } }

    context 'with valid parameters' do
      let(:request_params) do
        { wui_type: 'crash' }.merge(victim_params)
      end

      let(:notification) { double(:notification) }

      context 'with position' do
        let(:flag) { create(:flag, user: current_owner) }

        let(:victim_params) do
          { latitude: flag.latitude, longitude: flag.longitude }
        end

        let(:before_context) do
          allow(controller)
            .to receive(:notification_for).with(kind_of(Wui)).and_return(notification)

          expect(Pusher)
            .to receive(:trigger).with(current_owner.id.to_s, 'wui-create', notification)
        end

        it { is_expected.to respond_with(201) }

        it 'responds with right parameters' do
          expect(response_body.keys)
            .to eq %w(id wui_type status updated_at vehicle_identifier latitude longitude)
        end
      end

      context 'with vehicle' do
        let(:victim_params) { { vehicle_identifier: vehicle_identifier} }

        context 'with just one receiver' do
          let(:vehicle) { create(:vehicle, user: current_owner) }
          let(:vehicle_identifier) { vehicle.identifier }
          let(:before_context) { vehicle }

          context 'with successful pusher trigger' do
            let(:before_context) do
              allow(controller).to receive(:notification_for)
                .with(kind_of(Wui))
                .and_return(notification)

              expect(Pusher).to receive(:trigger)
                .with(current_owner.id.to_s, 'wui-create', notification)
            end

            it { is_expected.to respond_with(201) }

            it 'responds with right parameters' do
              expect(response_body.keys)
                .to eq %w(id wui_type status updated_at vehicle_identifier latitude longitude)
            end

            it 'creates the wui with :sent status' do
              expect(response_body['status']).to eq 'sent'
              expect(Wui.last.status).to eq 'sent'
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

        context 'with many receivers' do
          let(:user1) { create(:user) }
          let(:user2) { create(:user) }
          let(:user3) { create(:user) }
          let(:vehicle1) { create(:vehicle, user: user1) }
          let(:vehicle2) { create(:vehicle, user: user2, identifier: vehicle1.identifier ) }
          let(:vehicle3) { create(:vehicle, user: user3, identifier: vehicle1.identifier ) }
          let(:vehicle_identifier) { vehicle1.identifier }

          let(:notification) { double(:notification) }

          let(:before_context) do
            vehicle1
            vehicle2
            vehicle3

            allow(controller)
              .to receive(:notification_for).with(kind_of(Wui)).and_return(notification)

            expect(Pusher)
              .to receive(:trigger).with(user1.id.to_s, 'wui-create', notification)
            
            expect(Pusher)
              .to receive(:trigger).with(user2.id.to_s, 'wui-create', notification)
            
            expect(Pusher)
              .to receive(:trigger).with(user3.id.to_s, 'wui-create', notification)
          end

          it { is_expected.to respond_with 201 }
        end
      end
    end

    context 'with invalid parameters' do
      context 'with unexisting vehicle' do
        let(:request_params) do
          { wui_type: '' }
        end

        it { is_expected.to respond_with(422) }
        it 'responds with validation errors' do
          expect(response_body['errors'].keys).to include('wui_type')
        end
      end
    end
  end

  describe 'PUT #update', authenticated_resource: true do
    let(:action) { -> { put :update, request_params.merge(id: wui.id) } }

    let(:wui) do
      receiver.vehicles << create(:vehicle)
      receiver.save!
      create(:wui, vehicle_identifier: receiver.vehicles.first.identifier)
    end

    let(:receiver) { current_owner }

    let(:before_context) { wui }

    let(:request_params) do
      { status: new_status }
    end

    context 'with valid parameters' do
      let(:new_status) { 'received' }

      context 'with successful pusher trigger' do
        let(:notification) { double(:notification) }

        let(:before_context) do
          allow(controller).to receive(:notification_for)
            .with(kind_of(Wui))
            .and_return(notification)

          expect(Pusher).to receive(:trigger)
            .with(wui.user.id.to_s, 'wui-update', notification)
        end

        it { is_expected.to respond_with 200 }

        it 'responds with right parameters' do
          expect(response_body.keys)
            .to eq %w(id wui_type status updated_at vehicle_identifier latitude longitude)
        end

        it 'udates the wui' do
          expect(response_body['status']).to eq new_status
          expect(wui.reload.status).to eq new_status
        end
      end

      context 'with failing pusher trigger' do
        let(:before_context) do
          expect(Pusher).to receive(:trigger).and_raise(Pusher::Error)
          expect(Rollbar).to receive(:error)
        end

        it { is_expected.to respond_with 500 }
        it 'does not update the wui' do
          expect(wui.reload.status).to_not eq new_status
        end
      end

      context 'with not owner caller' do
        let(:receiver) { create(:user) }
        it { is_expected.to respond_with(404) }
      end
    end

    context 'with invalid parameters' do
      let(:new_status) { 'unexisting-status' }

      it { is_expected.to respond_with(422) }

      it 'responds with validation errors' do
        expect(response_body['errors'].keys).to eq ['status']
      end

      it 'does not update the wui' do
        expect(wui.reload.status).to_not eq new_status
      end
    end

    context 'with not permited parameters' do
      let(:new_type) { 'some-type' }
      let(:request_params) { { wui_type: new_type } }

      it { is_expected.to respond_with(400) }

      it 'does not update the wui' do
        expect(wui.reload.wui_type).to_not eq new_type
      end
    end
  end
end
