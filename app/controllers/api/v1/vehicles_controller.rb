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

      def with_current_owned_resource(&block)
        if current_resource
          if @current_resource.users.include?(current_owner)
            block.call(current_resource)
          else
            responder.not_found
          end
        else
          responder.not_found
        end
      end

      def current_resource
        klass = controller_name.singularize.camelize.constantize
        @current_resource ||= klass.find_by(id: params[:id])
      end
    end
  end
end
