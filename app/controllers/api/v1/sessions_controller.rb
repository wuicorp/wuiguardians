module Api
  module V1
    class SessionsController < ApiController
      def create
        @user = User.find_for_database_authentication(email: params[:email])
        if @user
          if @user.valid_password?(params[:password])
            success
          else
            render json: { user: :unauthorized }, status: 401
          end
        else
          @user = User.new(user_params)
          if @user.save
            success
          else
            render json: { errors: @user.errors }, status: 422
          end
        end
      end

      private

      def user_params
        params.permit(:email, :password, :password_confirmation)
      end

      def success
        render json: response_for_create, status: 201
      end

      def response_for_create
        token_response.merge(user: user_response)
      end

      def token_response
        access_token = find_or_create_access_token
        Doorkeeper::OAuth::TokenResponse.new(access_token).body
      end

      def user_response
        @user.as_json(only: [:id, :email])
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
