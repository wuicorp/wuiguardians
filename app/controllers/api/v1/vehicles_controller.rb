module Api
  module V1
    class VehiclesController < ApiController
      def create
        @vehicle = Vehicle.new(vehicle_params)
        @vehicle.users << current_owner
        if @vehicle.save
          responder.success(:create, @vehicle)
        else
          responder.invalid_resource(@vehicle)
        end
      end

      private

      def vehicle_params
        params.permit(:identifier)
      end
    end
  end
end
