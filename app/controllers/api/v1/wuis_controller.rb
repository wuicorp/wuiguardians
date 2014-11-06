module Api
  module V1
    class WuisController < ApiController
      before_action :authenticate!
      attr_accessor :wui

      def create
        @wui = Wui.new(wui_params_for_create)
        if @wui.save
          Pusher[wui_destination].trigger('wui_create', message: msg)
          render json: { result_type: :success }, status: 200
        else
          render json: @wui.as_json, status: 422
        end
      end

      def update
        @wui = Wui.find_by_id(wui_id)
        if @wui.update_attributes(wui_params_for_update)
          Pusher[wui_destination].trigger('wui_update', message: msg)
          render json: { result_type: :success }, status: 200
        else
          render json: @wui.as_json, status: 422
        end
      end

      private

      def wui_id
        params[:wui][:id] if params[:wui]
      end

      # Is just owner-receiver comunication, so the destination is
      #   who is not the caller (current_owner).
      def wui_destination
        if wui.vehicle_user_id == current_owner.id
          wui.user_id
        else
          wui.vehicle_user_id
        end.to_s
      end

      def msg
        { wui: wui, from: current_owner.id }.as_json
      end

      def wui_params_for_create
        return unless params[:wui]
        params.require(:wui)
          .merge(user: current_owner, vehicle: vehicle)
          .permit(:identifier, :user, :vehicle)
      end

      def wui_params_for_update
        return unless params[:wui]
        params.require(:wui)
          .permit(:identifier, :utility)
      end

      def vehicle
        return unless params[:vehicle]
        @vehicle ||= Vehicle.find_by_identifier(params[:vehicle][:identifier])
      end
    end
  end
end
