module Api
  module V1
    class UsersController < ApiController
      before_action :authenticate!

      def show
        respond_with User.find(params[:id])
      end

      def wui_alert
        Pusher[wui_alert_to].trigger('wui_alert', message: wui_alert_msg)
        render json: { result_type: :success }, status: 200
      end

      def wui_score
        Pusher[wui_score_to].trigger('wui_score', message: wui_score_msg)
        render json: { result_type: :success }, status: 200
      end

      private

      def caller_id
        params[:id]
      end

      def wui_alert_to
        Vehicle.find_by_identifier(params[:vehicle_identifier]).user_id
      end

      def wui_score_to
        params[:wui_alerter]
      end

      def wui_alert_msg
        { wui: params[:wui], from: caller_id }.as_json
      end

      def wui_score_msg
        { score: params[:score], from: caller_id }.as_json
      end
    end
  end
end
