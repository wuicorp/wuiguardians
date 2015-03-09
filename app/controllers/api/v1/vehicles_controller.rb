module Api
  module V1
    class VehiclesController < ApiController
      def create
        @vehicle = Vehicle.new(vehicle_params)
        render json: @vehicle.as_json, status: 201
      end

      private

      def vehicle_params
        params.permit(:identifier).merge(user_id: current_owner.id)
      end
    end
  end
end
