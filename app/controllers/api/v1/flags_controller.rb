module Api
  module V1
    class FlagsController < ApiController
      def show
        with_current_resource do |flag|
          render json: flag, root: false
        end
      end

      def create
        @flag = Flag.new(flag_params.merge(user_id: current_owner.id))

        if @flag.save
          responder.success(:create, @flag)
        else
          responder.invalid_resource(@flag)
        end
      end

      def update
        with_current_resource do |flag|
          with_filtered_params(flag_params) do |params|
            if flag.update(params)
              responder.success(:update, flag)
            else
              responder.invalid_resource(flag)
            end
          end
        end
      end

      private

      def flag_params
        params.permit(:longitude, :latitude, :radius)
      end
    end
  end
end
