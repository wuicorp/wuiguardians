module Api
  module V1
    class WuisController < ApiController
      def sent
        wuis = paginate(current_owner.sent_wuis)
        render json: wuis
      end

      def received
        wuis = paginate(current_owner.received_wuis)
        render json: wuis
      end

      def create
        Wui.transaction do
          @wui = Wui.new(wui_params_for_create)
          if @wui.save
            send_wui_notifications(@wui, 'wui-create')
            render status: 201, json: @wui
          else
            invalid_resource!(@wui)
          end
        end
      rescue Pusher::Error => e
        third_party_error!(e, 'Pusher.trigger error creating a Wui')
      end

      def update
        Wui.transaction do
          with_current_owned_resource do |wui|
            with_filtered_params(wui_params_for_update) do |parameters|
              if wui.update_attributes(parameters)
                send_wui_notifications(wui, 'wui-update')
                render json: wui
              else
                invalid_resource!(wui)
              end
            end
          end
        end
      rescue Pusher::Error => e
        third_party_error!(e, 'Pusher.trigger error updating a Wui')
      end

      private

      def send_wui_notifications(wui, message)
        receivers_for(wui).each do |receiver|
          Pusher.trigger(receiver.to_s, message, notification_for(wui))
        end
      end

      # Is just owner-receiver comunication, so the receiver is
      #   who is not the caller (current_owner).
      def receivers_for(wui)
        if wui.user == current_owner
          wui.users.map(&:id)
        else
          [wui.user_id]
        end
      end

      def notification_for(wui)
        wui.as_json(methods: nil)
      end

      def current_wui
        @current_wui ||= Wui.find_by(id: params[:id])
      end

      def wui_params_for_create
        params.merge(action: :sent,
                     user_id: current_owner.id)
          .permit(:wui_type, :user_id, :vehicle_identifier, :latitude, :longitude)
      end

      def wui_params_for_update
        params.permit(:status)
      end
    end
  end
end
