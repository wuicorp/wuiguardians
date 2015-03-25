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

      def success(action, resource = nil)
        case action
        when :get, :update
          render json: resource.as_json, status: 200
        when :create
          render json: resource.as_json, status: 201
        end
      end

      def invalid_resource(resource)
        render json: { errors: resource.errors }, status: 422
      end

      def third_party_error(e, msg)
        Rollbar.error(e, msg)
        render json: e.as_json, status: 500
      end

      def invalid_parameters
        error  = { errors: { invalid_request: 'No valid parameters found.' } }
        render json: error, status: 400
      end

      def with_filtered_params(params, &block)
        if params.empty?
          invalid_parameters
        else
          block.call(params)
        end
      end
    end
  end
end
