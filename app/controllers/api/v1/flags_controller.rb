module Api
  module V1
    class FlagsController < ApiController
      def create
        @flag = Flag.new(flag_params)

        if @flag.save
          responder.success(:create, @flag)
        else
          responder.invalid_resource(@flag)
        end
      end

      private

      def flag_params
        params.permit(:longitude, :latitude, :radius)
          .merge(user_id: current_owner.id)
      end
    end
  end
end
