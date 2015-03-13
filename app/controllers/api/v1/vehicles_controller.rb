module Api
  module V1
    class VehiclesController < ApiController
      def create
        @vehicle = Vehicle.new(vehicle_params)
        @vehicle.users << current_owner
        if @vehicle.save
          success :create
        else
          invalid_resource @vehicle
        end
      end

      private

      def vehicle_params
        params.permit(:identifier)
      end

      def success(action)
        case action
        when :create
          render json: vehicle_response, status: 201
        end
      end

      def vehicle_response
        @vehicle.as_json(only: [:id, :identifier])
      end
    end
  end
end
