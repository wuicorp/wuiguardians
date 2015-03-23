module Api
  module V1
    class UsersController < ApiController
      def me
        success :get, current_owner
      end
    end
  end
end
