shared_context 'authenticated resource', authenticated_resource: true do
  before do
    before_context if respond_to? :before_context
    request.headers[:authorization] = authorization
    action.call
  end

  let(:developer) { create(:user, role: 'developer') }
  let(:current_owner_password) { 'owner-secret' }
  let(:current_owner) { create(:user, password: current_owner_password) }
  let(:application) { create(:application, owner: developer) }
  let(:access_token) do
    create(:access_token,
           application: application,
           resource_owner_id: current_owner.id)
  end
  let(:token) { access_token.token }
  let(:authorization) { "Bearer #{token}" }
  let(:response_body) { JSON(response.body) }
end
