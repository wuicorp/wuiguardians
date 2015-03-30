module Api
  module V1
    class UsersController < ApiController
      def show
        with_current_user do |user|
          responder.success(:get, user)
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
    end
  end
end
