require 'rails_helper'

describe Api::V1::VehiclesController do
  it { is_expected.to be_a_kind_of Api::V1::ApiController }

  describe 'POST #create', authenticated_resource: true do
    let(:action) { -> { post :create, request_params } }

    context 'with valid parameters' do
      let(:request_params) { { identifier: '6699CMZ' } }
      it { is_expected.to respond_with(201) }
      it 'responds with created vehicle' do
        expect(response_body).to include 'id'
        expect(response_body).to include 'identifier'
        expect(response_body).to_not include 'users'
      end
    end

    context 'with invalid parameters' do
      let(:request_params) { {} }
      it 'responds with validation errors' do
        expect(response_body['errors']).to include 'identifier'
      end
    end
  end
end
