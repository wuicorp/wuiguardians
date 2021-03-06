require 'rails_helper'

describe Api::V1::UsersController do
  it { is_expected.to be_a_kind_of Api::V1::ApiController }

  shared_examples 'not found with any id different of me' do
    let(:request_params) { { id: '1' } }
    it { is_expected.to respond_with(404) }
  end

  describe 'GET #show', authenticated_resource: true do
    let(:action) { -> { get :show, request_params } }

    it_behaves_like 'not found with any id different of me'

    context 'with me id' do
      let(:request_params) { { id: 'me' } }
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
          build(:vehicle, vattrs1).tap { |v| v.user = current_owner }.save
          build(:vehicle, vattrs2).tap { |v| v.user = current_owner }.save
        end

        it 'responds with owned vehicles' do
          expect(response_vehicles.count).to eq 2
          expect(response_vehicles).to include vattrs1.stringify_keys
          expect(response_vehicles).to include vattrs2.stringify_keys
        end
      end
    end
  end

  describe 'PUT #update', authenticated_resource: true do
    let(:action) { -> { put :update, request_params } }

    it_behaves_like 'not found with any id different of me'

    context 'with me id' do
      let(:request_params) { { id: 'me' } }

      context 'with valid parameters' do
        let(:new_name) { 'new-name' }
        let(:new_email) { 'new@email.com' }
        let(:new_password) { 'new-secret' }
        let(:new_params) do
          { name: new_name,
            email: new_email,
            password: new_password }
        end
        let(:before_context) { request_params.merge!(new_params) }

        it { is_expected.to respond_with(200) }

        it 'responds with parameter updated' do
          expect(response_body['name']).to eq new_name
          # Email Is not gonna be confirmed directly, so it's the older one
          expect(response_body['email']).to_not eq new_name
        end

        it 'updates the user' do
          current_owner.reload
          expect(current_owner.name).to eq new_name
          expect(current_owner.valid_password?(new_password)).to be true
        end

        context 'unconfirmed email' do
          subject { current_owner.reload }
          its(:email) { is_expected.to_not eq new_email }
        end

        context 'confirmed email' do
          subject { current_owner.reload.tap { |u| u.confirm! } }
          its(:email) { is_expected.to eq new_email }
        end
      end

      context 'with invalid parameters' do
        let(:new_email) { 'new-invalid-email' }
        let(:before_context) { request_params.merge!(email: new_email) }

        it { is_expected.to respond_with(422) }

        it 'responds with validation errors' do
          expect(response_body['errors']).to include 'email'
        end

        it 'does not update the invalid field' do
          expect(current_owner.reload.email).to_not eq new_email
        end
      end

      context 'with not permited parameters' do
        let(:before_context) { request_params.merge!(some: 'filtered') }
        it { is_expected.to respond_with(400) }
      end
    end
  end
end
