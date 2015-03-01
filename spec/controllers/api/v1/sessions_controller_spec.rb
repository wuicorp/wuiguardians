require 'rails_helper'

describe Api::V1::SessionsController do
  describe 'POST #create' do
    context 'without authorization header' do
      before { post :create }
      it { is_expected.to respond_with(401) }
    end

    context 'with authorization header' do
      before do
        request.headers[:authorization] = "Bearer #{token}"
        post :create, request_params
      end

      context 'with valid token' do
        let(:developer) { create(:user, role: 'developer') }
        let(:application) { create(:application, owner: developer) }
        let(:access_token) { create(:access_token, application: application) }
        let(:token) { access_token.token }

        context 'with unexisting user' do
          context 'with valid parameters' do
            let(:email) { 'user@mail.com' }
            let(:password) { '12345678' }
            let(:request_params) do
              { email: email, password: password }
            end

            it { is_expected.to respond_with(201) }
            it 'creates the user' do
              expect(User.last.email).to eq email
            end
          end

          context 'with invalid parameters' do
            let(:request_params) { {} }
            it { is_expected.to respond_with(422) }
          end
        end

        context 'with existing user' do
          let(:user) { create(:user) }

          context 'with right authentication parameters' do
            let(:request_params) do
              { email: user.email, password: user.password }
            end
            it { is_expected.to respond_with(201) }
          end

          context 'with wrong authentication parameters' do
            let(:request_params) { { email: user.email, password: 'foo' } }
            it { is_expected.to respond_with(401) }
          end
        end
      end
    end
  end
end
