module Api
  module V1
    class WuisController < ApiController
      before_action :authenticate!

      def create
        Pusher[wui_destination].trigger('wui_create', message: msg)
        render json: { result_type: :success }, status: 200
      end

      def update
        Pusher[wui_destination].trigger('wui_update', message: msg)
        render json: { result_type: :success }, status: 200
      end

      private

      def wui_destination
        return wui_owner_id if wui_receiver_id == current_owner.id
        wui_receiver_id
      end

      def wui_owner_id
        return unless params[:wui]
        params[:wui][:owner_id]
      end

      def wui_receiver_id
        return unless params[:wui]
        @wui_receiver_id ||= params[:wui][:receiver_id] || vehicle_owner_id
      end

      def msg
        { wui: params[:wui], from: current_owner.id }.as_json
      end

      def vehicle_owner_id
        return unless vehicle
        vehicle.user_id.to_s
      end

      def vehicle
        return unless params[:vehicle]
        @vehicle ||= Vehicle.find_by_identifier(params[:vehicle][:identifier])
      end
    end
  end
end
