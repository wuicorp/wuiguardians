module Api
  module V1
    class SessionsController < ApiController
      def create
        user = User.new(user_params)
        app = current_application
        if app && user.save
          create_successful_response(app, user)
        else
          errors = app ? user.errors : { application: :invalid }
          render json: errors, status: 422
        end
      end

      private

      def user_params
        params.permit(:email, :password, :password_confirmation)
      end

      def find_or_create_access_token(app, user)
        Doorkeeper::AccessToken.find_or_create_for(
          app,
          user.id,
          nil,
          Doorkeeper.configuration.access_token_expires_in,
          Doorkeeper.configuration.refresh_token_enabled?
        )
      end

      def create_successful_response(app, user)
        access_token = find_or_create_access_token(app, user)
        render(json: Doorkeeper::OAuth::TokenResponse.new(access_token).body,
               status: 201)
      end
    end
  end
end
