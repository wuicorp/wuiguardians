module Api
  module V1
    class ApiController < ::ApplicationController
      respond_to :json
      before_action :doorkeeper_authorize!
      skip_before_filter :verify_authenticity_token
      serialization_scope :view_context

      def default_serializer_options
        { root: false }
      end

      # Find the user that owns the access token
      def current_owner
        return unless doorkeeper_token && doorkeeper_token.resource_owner_id
        @current_owner ||= User.find(doorkeeper_token.resource_owner_id)
      end

      def current_application
        return unless doorkeeper_token && doorkeeper_token.application_id
        @current_application ||= Doorkeeper::Application.find(doorkeeper_token.application_id)
      end

      def with_filtered_params(params, &block)
        if params.empty?
          invalid_parameters!
        else
          block.call(params)
        end
      end

      def with_current_owned_resource(&block)
        with_current_resource do |resource|
          if resource.owned_by?(current_owner)
            block.call(resource)
          else
            not_found!
          end
        end
      end

      def with_current_resource(&block)
        if current_resource
          block.call(current_resource)
        else
          not_found!
        end
      end

      def current_resource
        klass = controller_name.singularize.camelize.constantize
        @current_resource ||= klass.find_by(id: params[:id])
      end

      def invalid_resource!(resource)
        render status: 422, json: { errors: resource.errors }
      end

      def invalid_parameters!
        body = { errors: { invalid_request: 'invalid_parameters' } }
        render json: body, status: 400
      end

      def not_found!
        render json: nil, status: 404
      end

      def third_party_error!(error, message)
        Rollbar.error(error, message)
        render json: error.as_json, status: 500
      end
    end
  end
end
