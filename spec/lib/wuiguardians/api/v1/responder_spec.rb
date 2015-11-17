require 'rails_helper'
require 'wuiguardians/api/v1/responder'

describe Wuiguardians::Api::V1::Responder do
  let(:controller) { double(:controller) }
  let(:described_instance) { described_class.new(controller) }

  describe '#success' do
    shared_examples 'success response' do |status|
      let(:resource) { double(:resource) }

      after { described_instance.success(action, resource) }

      it 'calls render with resource as json and right status' do
        expect(controller).to receive(:render)
          .with(json: resource.as_json, status: status, serializer: nil)
      end
    end

    context 'with get action' do
      let(:action) { :get }
      it_behaves_like 'success response', 200
    end

    context 'with update action' do
      let(:action) { :update }
      it_behaves_like 'success response', 200
    end

    context 'with create action' do
      let(:action) { :create }
      it_behaves_like 'success response', 201
    end
  end

  describe '#invalid_resource' do
    let(:resource) { double(:resource, errors: double(:errors)) }

    after { described_instance.invalid_resource(resource) }

    it 'calls render with resource errors as json and right status' do
      expect(controller).to receive(:render)
        .with(json: { errors: resource.errors }, status: 422)
    end
  end

  describe '#third_party_error' do
    let(:error) { double(:error) }
    let(:message) { double(:message) }

    after { described_instance.third_party_error(error, message) }

    it 'renders the error and notifies rollbar with the message' do
      expect(Rollbar).to receive(:error).with(error, message)
      expect(controller).to receive(:render)
        .with(json: error.as_json, status: 500)
    end
  end

  describe '#invalid_parameters' do
    after { described_instance.invalid_parameters }

    it 'calls render with unauthorized error' do
      expect(controller).to receive(:render)
        .with(json: { errors: { invalid_request: 'invalid_parameters' } },
              status: 400)
    end
  end

  describe '#unauthorized' do
    after { described_instance.unauthorized }

    it 'calls render with unauthorized error' do
      expect(controller).to receive(:render)
        .with(json: { errors: { user: 'unauthorized' } },
              status: 401)
    end
  end
end
