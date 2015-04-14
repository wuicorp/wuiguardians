require 'rails_helper'

describe Api::V1::VehiclesController do
  it { is_expected.to be_a_kind_of Api::V1::ApiController }

  describe 'POST #create', authenticated_resource: true do
    let(:action) { -> { post :create, request_params } }

    context 'with valid parameters' do
      let(:request_params) { { identifier: '6699CMZ' } }
      it { is_expected.to respond_with(201) }
      it 'responds with created vehicle' do
        expect(response_body).to include 'id'
        expect(response_body).to include 'identifier'
        expect(response_body).to_not include 'users'
      end
    end

    context 'with invalid parameters' do
      let(:request_params) { {} }
      it 'responds with validation errors' do
        expect(response_body['errors']).to include 'identifier'
      end
    end
  end

  describe 'DELETE #vehicle', authenticated_resource: true do
    let(:action) { -> { delete :destroy, request_params } }

    let(:request_params) { { id: vehicle.id } }

    context 'vehicle owned by current owner' do
      context 'existing vehicle' do
        let(:before_context) do
          current_owner.vehicles << vehicle
          current_owner.save!
        end

        context 'just by owner' do
          let(:vehicle) { create(:vehicle) }

          it { is_expected.to respond_with(200) }

          it 'destroys the vehicle' do
            expect(Vehicle.count).to eq 0
          end
        end

        context 'also by other users' do
          let(:vehicle) do
            create(:vehicle).tap do |v|
              v.users << create(:user)
              v.save!
            end
          end

          it { is_expected.to respond_with(200) }

          it 'does not destroy the vehicle' do
            expect(Vehicle.count).to eq 1
          end

          it 'does not destroy the caller user' do
            expect(User.find(current_owner.id)).to_not be_nil
          end

          it 'removes vehicle relation with caller user' do
            expect(current_owner.reload.vehicles).to_not include vehicle
          end
        end
      end

      context 'vehicle does not owned by current owner' do
        let(:vehicle) do
          create(:vehicle).tap do |v|
            v.users << create(:user)
            v.save!
          end
        end

        it { is_expected.to respond_with(404) }
      end
    end

    context 'with unexisting vehicle id' do
      let(:request_params) { { id: 1 } }
      it { is_expected.to respond_with(404) }
    end
  end
end
