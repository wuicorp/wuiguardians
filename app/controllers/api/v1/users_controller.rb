module Api
  module V1
    class UsersController < ApiController
      include Tubesock::Hijack

      before_action :authenticate!, only: [:show]

      def create
        respond_with User.create(params[:user])
      end

      def show
        respond_with User.find(params[:id])
      end

      def connect
        hijack do |tubesock|
          tubesock.onopen do
            tubesock.send_data 'Connected...'
          end

          tubesock.onmessage do |data|
            tubesock.send_data "You said: #{data}"
          end
        end
      end

      private

      def caller_id
        params[:id]
      end
    end
  end
end
