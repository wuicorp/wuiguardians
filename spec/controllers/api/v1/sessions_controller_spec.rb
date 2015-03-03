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
      let(:response_body) { JSON(response.body) }

      context 'with valid token' do
        let(:developer) { create(:user, role: 'developer') }
        let(:application) { create(:application, owner: developer) }
        let(:access_token) { create(:access_token, application: application) }
        let(:token) { access_token.token }

        shared_examples 'successful response' do
          it { is_expected.to respond_with(201) }
          it 'responds with access_token' do
            expect(response_body).to include 'access_token'
            expect(response_body).to include 'expires_in'
            expect(response_body).to include 'refresh_token'
            expect(response_body).to include 'token_type'
          end
          it 'responds with the user' do
            expect(response_body['user']['email']).to eq email
          end
        end

        context 'with unexisting user' do
          context 'with valid parameters' do
            let(:email) { 'user@mail.com' }
            let(:password) { '12345678' }
            let(:request_params) do
              { email: email, password: password }
            end
            
            it_behaves_like 'successful response'
            it 'creates the user' do
              expect(User.last.email).to eq email
            end
          end

          context 'with invalid parameters' do
            let(:request_params) { {} }
            it { is_expected.to respond_with(422) }
            it 'respond with validation errors' do
              expect(response_body['errors']).to include 'email'
              expect(response_body['errors']).to include 'password'
            end
          end
        end

        context 'with existing user' do
          let(:user) { create(:user) }
          let(:email) { user.email }
          let(:password) { user.password }

          context 'with right authentication parameters' do
            let(:request_params) do
              { email: email, password: password }
            end
            it_behaves_like 'successful response'
          end

          context 'with wrong authentication parameters' do
            let(:request_params) { { email: email, password: 'foo' } }
            it { is_expected.to respond_with(401) }
          end
        end
      end
    end
  end
end
