module Api
  module V1
    class ApiController < ::ApplicationController
      respond_to :json
      doorkeeper_for :all
      skip_before_filter :verify_authenticity_token

      # Find the user that owns the access token
      def current_owner
        return unless doorkeeper_token.resource_owner_id
        @current_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      # Checks that the "caller" is the owner of the token.
      def authenticate!
        unauthorized! if !current_owner || (current_owner.id != caller_id.to_i)
      end

      def unauthorized!
        render json: { error: :unautorized }, status: :unauthorized
      end
    end
  end
end
