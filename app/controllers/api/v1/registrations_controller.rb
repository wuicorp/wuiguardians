module Api
  module V1
    class RegistrationsController < ApiController
      def create
        @user = User.new(user_params)
        if @user.save
          responder.success(:create, response_for_create)
        else
          responder.invalid_resource(@user)
        end
      end

      private

      def user_params
        params.permit(:email, :password, :password_confirmation)
      end

      def response_for_create
        token_response.merge(user: user_response)
      end

      def token_response
        access_token = find_or_create_access_token
        Doorkeeper::OAuth::TokenResponse.new(access_token).body
      end

      def user_response
        @user.as_json
      end

      def find_or_create_access_token
        Doorkeeper::AccessToken.find_or_create_for(
          current_application,
          @user.id,
          nil,
          Doorkeeper.configuration.access_token_expires_in,
          Doorkeeper.configuration.refresh_token_enabled?
        )
      end
    end
  end
end
