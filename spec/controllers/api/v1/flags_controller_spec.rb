require 'rails_helper'

describe Api::V1::FlagsController do
  it { is_expected.to be_a_kind_of Api::V1::ApiController }

  describe 'POST #create', authenticated_resource: true do
    let(:action) { -> { post :create, request_params } }

    context 'with valid parameters' do
      let(:request_params) do
        { longitude: '0.0',
          latitude: '0.0',
          radius: '10' }
      end

      it { is_expected.to respond_with(201) }

      it 'responds with created flag' do
        expect(response_body).to include 'id'
        expect(response_body).to include 'longitude'
        expect(response_body).to include 'latitude'
        expect(response_body).to include 'radius'
      end

      it 'creates the flag' do
        expect(Flag.count).to eq 1
      end

      it 'created flag belongs to the current owner' do
        expect(Flag.last.user).to eq current_owner
      end
    end

    context 'with invalid parameters' do
      let(:request_params) {}
      it 'responds with validation errors' do
        expect(response_body['errors'].keys).to eq ['longitude', 'latitude', 'radius']
      end
    end
  end

  describe 'PUT #update', authenticated_resource: true do
    let(:action) { -> { put :update, request_params } }

    context 'with unexisting flag' do
      let(:request_params) { { id: 'unexisting' } }

      it 'responds with not found' do
        expect(response.status).to eq 404
      end
    end

    context 'with existing flag' do
      let(:flag) { create(:flag) }

      let(:request_params) do
        { id: flag.id }.merge(flag_params)
      end

      context 'with valid parameters' do
        let(:flag_params) do
          { longitude: '2.0' }
        end

        it { is_expected.to respond_with(200) }

        it 'updates the flag' do
          expect(flag.reload.longitude).to eq 2.0
        end
      end

      context 'with invalid parameters' do
        let(:flag_params) do
          { longitude: 'xx',
            latitude: 'xx',
            radius: 'xx' }
        end

        it { is_expected.to respond_with(422) }

        it 'responds with validation errors' do
          expect(response_body['errors'].keys)
            .to eq %w(longitude latitude radius)
        end
      end
    end
  end

  describe 'GET #show', authenticated_resource: true do
    let(:action) { -> { get :show, request_params } }

    context 'with unexisting flag' do
      let(:request_params) { { id: 'unexisting' } }

      it 'responds with not found' do
        expect(response.status).to eq 404
      end
    end

    context 'with existing flag' do
      let(:flag) { create(:flag) }

      let(:request_params) { { id: flag.id } }

      it { is_expected.to respond_with(200) }

      it 'responds with the flag' do
        expect(response_body).to eq('id' => flag.id,
                                    'longitude' => flag.longitude,
                                    'latitude' => flag.latitude,
                                    'radius' => flag.radius,
                                    'created_at' => flag.created_at.as_json,
                                    'updated_at' => flag.updated_at.as_json)
      end
    end
  end

  describe 'DELET #destroy', authenticated_resource: true do
    let(:action) { -> { delete :destroy, request_params } }

    context 'with unexisting flag' do
      let(:request_params) { { id: 'unexisting' } }

      it 'responds with not found' do
        expect(response.status).to eq 404
      end
    end

    context 'with existing flag' do
      let(:flag) { create(:flag) }

      let(:request_params) { { id: flag.id } }

      it { is_expected.to respond_with(204) }

      it 'destroys the flag' do
        expect(Flag.count).to eq 0
      end
    end
  end
end
