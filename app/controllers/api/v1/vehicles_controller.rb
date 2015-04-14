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

      def destroy
        with_current_owned_resource do |vehicle|
          if vehicle.just_belongs_to?(current_owner)
            vehicle.destroy
          else
            vehicle.users.delete(current_owner)
          end

          responder.success(:delete, vehicle)
        end
      end

      private

      def vehicle_params
        params.permit(:identifier)
      end
    end
  end
end
