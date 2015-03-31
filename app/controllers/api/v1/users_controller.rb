module Api
  module V1
    class UsersController < ApiController
      def show
        with_current_user do |user|
          responder.success(:get, user)
        end
      end

      def update
        with_current_user do |user|
          with_filtered_params(params_for_update) do |params|
            if user.update_attributes(params)
              responder.success(:update, user)
            else
              responder.invalid_resource(user)
            end
          end
        end
      end

      private

      def current_user
        return @current_user ||=  current_owner if params[:id] == 'me'
        nil
      end

      def with_current_user(&block)
        current_user ? block.call(current_user) : responder.not_found
      end

      def params_for_update
        params.permit(:email, :name)
      end
    end
  end
end
