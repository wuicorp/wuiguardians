module Api
  module V1
    class UsersController < ApiController
      before_action :authenticate!, only: [:show]

      def create
        respond_with User.create(params[:user])
      end

      def show
        respond_with User.find(params[:id])
      end

      private

      def caller_id
        params[:id]
      end
    end
  end
end
