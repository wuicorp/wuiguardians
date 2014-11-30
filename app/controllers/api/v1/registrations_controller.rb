module Api
  module V1
    class RegistrationsController < ApiController
      def create
        user = User.new(user_params)
        if user.save
          token = create_access_token!(user).token
          render(json: { user: user.as_json, access_token: token },
                 status: 201)
        else
          warden.custom_failure!
          render json: user.errors, status: 422
        end
      end

      private

      def user_params
        params.require(:user).permit(:phone_number,
                                     vehicles_attributes: [:identifier])
      end

      def client_id
        params[:client_id]
      end

      def create_access_token!(user)
        Doorkeeper::AccessToken.create!(application_id: client_id,
                                        resource_owner_id: user.id)
      end
    end
  end
end
