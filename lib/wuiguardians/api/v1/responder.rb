module Wuiguardians
  module Api
    module V1
      class Responder
        attr_accessor :controller

        def initialize(controller)
          @controller = controller
        end

        def success(action, resource = nil)
          case action
          when :get, :update, :delete
            controller.render json: resource.as_json, status: 200, serializer: nil
          when :create
            controller.render json: resource.as_json, status: 201, serializer: nil
          end
        end

        def invalid_resource(resource)
          controller.render json: { errors: resource.errors }, status: 422
        end

        def third_party_error(error, message)
          Rollbar.error(error, message)
          controller.render json: error.as_json, status: 500
        end

        def invalid_parameters
          body  = { errors: { invalid_request: 'invalid_parameters' } }
          controller.render json: body, status: 400
        end

        def unauthorized
          body = { errors: { user: 'unauthorized' } }
          controller.render json: body, status: 401
        end

        def not_found
          controller.render json: nil, status: 404
        end
      end
    end
  end
end
