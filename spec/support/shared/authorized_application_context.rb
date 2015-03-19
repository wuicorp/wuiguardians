shared_context 'authorized application', authorized_application: true do
  before do
    request.headers[:authorization] = authorization
    action.call
  end

  let(:developer) { create(:user, role: 'developer') }
  let(:application) { create(:application, owner: developer) }
  let(:access_token) { create(:access_token, application: application) }
  let(:token) { access_token.token }
  let(:authorization) { "Bearer #{token}" }
  let(:response_body) { JSON(response.body) }
end
