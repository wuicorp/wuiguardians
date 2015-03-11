shared_context 'authenticated resource', authenticated_resource: true do
  before do
    before_context if respond_to? :before_context
    request.headers[:authorization] = authorization
    action.call
  end

  let(:developer) { create(:user, role: 'developer') }
  let(:user) { create(:user) }
  let(:application) { create(:application, owner: developer) }
  let(:access_token) do
    create(:access_token, application: application, resource_owner_id: user.id)
  end
  let(:token) { access_token.token }
  let(:authorization) { "Bearer #{token}" }
  let(:response_body) { JSON(response.body) }
end
