module Api
  module V1
    class WuisController < ApiController
      def index
        responder.success(:get, all_wuis)
      end

      def create
        Wui.transaction do
          @wui = Wui.new(wui_params_for_create)
          if @wui.save
            send_wui_notifications(@wui, 'wui-create')
            responder.success(:create, @wui)
          else
            responder.invalid_resource(@wui)
          end
        end
      rescue Pusher::Error => e
        responder.third_party_error(e, 'Pusher.trigger error creating a Wui')
      end

      def update
        Wui.transaction do
          with_filtered_params(wui_params_for_update) do |parameters|
            if current_wui.update_attributes(parameters)
              send_wui_notifications(current_wui, 'wui-update')
              responder.success(:update, current_wui)
            else
              responder.invalid_resource(current_wui)
            end
          end
        end
      rescue Pusher::Error => e
        responder.third_party_error(e, 'Pusher.trigger error updating a Wui')
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

      def send_wui_notifications(wui, message)
        receivers_for(wui).each do |receiver|
          Pusher.trigger(receiver.to_s, message, notification_for(wui))
        end
      end

      # Is just owner-receiver comunication, so the receiver is
      #   who is not the caller (current_owner).
      def receivers_for(wui)
        if wui.vehicle.belongs_to?(current_owner)
          [wui.user_id]
        else
          wui.vehicle_users.map(&:id)
        end
      end

      def notification_for(wui)
        wui.as_json(methods: nil)
      end

      def current_wui
        @current_wui ||= Wui.find_by(params[:id])
      end

      def wui_params_for_create
        params.merge(action: :sent,
                     user_id: current_owner.id,
                     vehicle_id: vehicle_id_from_params)
          .permit(:wui_type, :user_id, :vehicle_id)
      end

      def wui_params_for_update
        params.permit(:status)
      end

      def vehicle_id_from_params
        Vehicle.find_by(identifier: params[:vehicle_identifier]).try(:id)
      end
    end
  end
end
