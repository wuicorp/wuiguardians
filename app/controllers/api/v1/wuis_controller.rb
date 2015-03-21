module Api
  module V1
    class WuisController < ApiController
      def index
        render json: all_wuis, status: 200
      end

      def create
        @wui = Wui.new(wui_params_for_create)
        if @wui.save
          Pusher.trigger(receiver_for(@wui), 'wui_create', notification_for(@wui))
          render json: @wui.as_json, status: 201
        else
          invalid_resource @wui
        end
      rescue Pusher::Error => e
        @wui.destroy
        third_party_error e
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

      def received_wuis
        current_owner.find_all_received_wuis.to_a.map do |wui|
          wui.as_json.merge(action: :received)
        end
      end

      def sent_wuis
        current_owner.wuis.to_a.map do |wui|
          wui.as_json.merge(action: :sent)
        end
      end

      def all_wuis
        (received_wuis + sent_wuis).sort_by { |w| w[:updated_at] }.reverse
      end

      # Is just owner-receiver comunication, so the receiver is
      #   who is not the caller (current_owner).
      def receiver_for(wui)
        if wui.vehicle.users.includes(current_owner)
          wui.user_id
        else
          wui.vehicle_user_id
        end.to_s
      end

      def notification_for(wui)
        wui.as_json(methods: nil)
      end

      def wui_id
        params[:wui][:id] if params[:wui]
      end

      def wui_params_for_create
        params.merge(action: :sent,
                     user_id: current_owner.id,
                     vehicle_id: vehicle_id_from_params)
          .permit(:wui_type, :user_id, :vehicle_id)
      end

      def wui_params_for_update
        return unless params[:wui]
        params.require(:wui)
          .permit(:identifier, :utility)
      end

      def vehicle_id_from_params
        Vehicle.find_by(identifier: params[:vehicle_identifier]).try(:id)
      end
    end
  end
end
