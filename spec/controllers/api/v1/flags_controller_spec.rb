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

      let(:before_context) do
        expect_any_instance_of(Wuinloc::Service).to receive(:save_flag)
      end

      it { is_expected.to respond_with(201) }

      it 'responds with created flag' do
        expect(response_body).to include 'id'
        expect(response_body).to include 'longitude'
        expect(response_body).to include 'latitude'
        expect(response_body).to include 'radius'
      end
    end

    context 'with invalid parameters' do
      let(:request_params) {}
      it 'responds with validation errors' do
        expect(response_body['errors'].keys).to eq ['longitude', 'latitude', 'radius']
      end
    end
  end
end