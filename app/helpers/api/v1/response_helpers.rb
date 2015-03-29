require 'wuiguardians/api/v1/responder'

module Api
  module V1
    module ResponseHelpers
      def responder
        @responder ||= Wuiguardians::Api::V1::Responder.new(self)
      end
    end
  end
end
