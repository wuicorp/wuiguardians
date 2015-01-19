module Api
  module V1
    class UsersController < ApiController
      def me
        respond_with current_owner
      end
    end
  end
end
