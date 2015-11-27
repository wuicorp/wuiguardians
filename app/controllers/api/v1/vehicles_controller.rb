module Api
  module V1
    class VehiclesController < ApiController
      def index
        vehicles = paginate(current_owner.vehicles)
        render json: vehicles
      end

      def create
        @vehicle = Vehicle.new(vehicle_params)
        @vehicle.user = current_owner
        if @vehicle.save
          render status: 201, json: @vehicle
        else
          invalid_resource!(@vehicle)
        end
      end

      def update
        with_current_owned_resource do |vehicle|
          with_filtered_params(vehicle_params) do |params|
            if vehicle.update(params)
              render json: vehicle
            else
              invalid_resource!(vehicle)
            end
          end
        end
      end

      def destroy
        with_current_owned_resource do |vehicle|
          vehicle.destroy
          render json: vehicle
        end
      end

      private

      def vehicle_params
        params.permit(:identifier)
      end
    end
  end
end
