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

      # Checks that the "caller" is the owner of the token.
      def authenticate_resource!
        unauthorized! if !current_owner || (current_owner.id != resource_id.to_i)
      end

      def authenticate!
        unauthorized! unless current_owner
      end

      def unauthorized!
        render json: { error: :unautorized }, status: :unauthorized
      end
    end
  end
end
