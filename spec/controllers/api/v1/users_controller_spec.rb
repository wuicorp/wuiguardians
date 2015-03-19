require 'rails_helper'

describe Api::V1::UsersController do
  it { is_expected.to be_a_kind_of Api::V1::ApiController }

  describe 'GET #me', authenticated_resource: true do
    let(:action) { -> { get :me } }
    let(:response_vehicles) { response_body['vehicles'] }

    it { is_expected.to respond_with(200) }

    it 'responds with right parameters' do
      expect(response_body).to include 'id'
      expect(response_body).to include 'email'
      expect(response_body).to include 'name'
      expect(response_body).to_not include 'role'
      expect(response_body).to_not include 'created_at'
      expect(response_body).to_not include 'updated_at'
    end

    context 'without vehicles' do
      it 'responds with empty list of vehicles' do
        expect(response_vehicles).to eq []
      end
    end

    context 'with vehicles' do
      let(:vattrs1) { { id: 1, identifier: '1111111' } }
      let(:vattrs2) { { id: 2, identifier: '2222222' } }

      let(:before_context) do
        build(:vehicle, vattrs1).tap { |v| v.users << current_owner }.save
        build(:vehicle, vattrs2).tap { |v| v.users << current_owner }.save
      end

      it 'responds with owned vehicles' do
        expect(response_vehicles.count).to eq 2
        expect(response_vehicles).to include vattrs1.stringify_keys
        expect(response_vehicles).to include vattrs2.stringify_keys
      end
    end
  end
end
