module Api
  module V1
    class UsersController < ApiController
      def me
        render json: me_response, status: 200
      end

      private

      def me_response
        current_owner.as_json(
          only: [:id, :email, :name],
          include: { vehicles: { only: [:id, :identifier] } }
        )
      end
    end
  end
end
