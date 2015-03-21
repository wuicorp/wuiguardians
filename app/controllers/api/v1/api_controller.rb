module Api
  module V1
    class ApiController < ::ApplicationController
      respond_to :json
      before_action :doorkeeper_authorize!
      skip_before_filter :verify_authenticity_token

      # Find the user that owns the access token
      def current_owner
        return unless doorkeeper_token && doorkeeper_token.resource_owner_id
        @current_owner ||= User.find(doorkeeper_token.resource_owner_id)
      end

      def current_application
        return unless doorkeeper_token && doorkeeper_token.application_id
        @current_application ||= Doorkeeper::Application.find(doorkeeper_token.application_id)
      end

      def invalid_resource(resource)
        render json: { errors: resource.errors }, status: 422
      end

      def third_party_error(e)
        render json: { error: :third_party_error, description: e.as_json }, status: 400
      end
    end
  end
end
