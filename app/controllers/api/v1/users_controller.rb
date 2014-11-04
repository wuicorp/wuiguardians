module Api
  module V1
    class UsersController < ApiController
      before_action :authenticate_resource!

      def show
        respond_with User.find(params[:id])
      end

      private

      def resource_id
        params[:id]
      end
    end
  end
end
