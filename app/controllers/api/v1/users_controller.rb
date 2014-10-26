module Api
  module V1
    class UsersController < Api::V1::BaseController
      include Tubesock::Hijack

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
    end
  end
end
