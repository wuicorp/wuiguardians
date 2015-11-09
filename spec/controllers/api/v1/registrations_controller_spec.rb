require 'rails_helper'

describe Api::V1::RegistrationsController do
  describe 'POST #create' do
    it { is_expected.to be_a_kind_of Api::V1::ApiController }

    context 'valid authorization' do
      let(:action) { -> { post :create, request_params } }

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

      context 'with unexisting user', authorized_application: true do
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
          it 'responds with validation errors' do
            expect(response_body['errors']).to include 'email'
            expect(response_body['errors']).to include 'password'
          end
        end
      end

      context 'with existing user', authenticated_resource: true do
        let(:user) { create(:user) }

        let(:request_params) do
          { email: user.email, password: user.password }
        end

        it { is_expected.to respond_with(422) }
        it 'responds taken error' do
          expect(response_body['errors']['email'].first)
            .to eq I18n.t('errors.messages.taken')
        end
      end
    end
  end
end
