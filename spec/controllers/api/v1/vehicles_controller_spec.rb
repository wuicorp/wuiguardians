require 'rails_helper'

describe Api::V1::VehiclesController do
  it { is_expected.to be_a_kind_of Api::V1::ApiController }

  describe 'POST #create', authenticated_resource: true do
    let(:action) { -> { post :create, request_params } }

    context 'with valid parameters' do
      let(:request_params) { { identifier: '6699CMZ' } }
      it { is_expected.to respond_with(201) }
    end
  end
end
