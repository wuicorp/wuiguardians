module Api
  module V1
    class ApiController < ::ApplicationController
      include Api::V1::ResponseHelpers

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

      def with_filtered_params(params, &block)
        if params.empty?
          responder.invalid_parameters
        else
          block.call(params)
        end
      end

      def with_current_owned_resource(&block)
        with_current_resource do |resource|
          if resource.owned_by?(current_owner)
            block.call(resource)
          else
            responder.not_found
          end
        end
      end

      def with_current_resource(&block)
        if current_resource
          block.call(current_resource)
        else
          responder.not_found
        end
      end

      def current_resource
        klass = controller_name.singularize.camelize.constantize
        @current_resource ||= klass.find_by(id: params[:id])
      end
    end
  end
end
