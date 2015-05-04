shared_examples 'get sent or received wuis' do |wuis_action|
  let(:action) { -> { get wuis_action } }

  it { is_expected.to respond_with 200 }

  context 'without existing wuis' do
    it 'responds with empty list' do
      expect(response_body).to eq []
    end
  end

  context 'with sent and received wuis' do
    let(:received) do
      sender = create(:user)
      vehicle = build(:vehicle)
      vehicle.users << current_owner
      create(:wui,
             user: sender,
             vehicle: vehicle,
             updated_at: 2.minutes.ago)
    end

    let(:sent) do
      receiver = create(:user)
      vehicle = build(:vehicle)
      vehicle.users << receiver
      create(:wui,
             user: current_owner,
             vehicle: vehicle,
             updated_at: 1.minute.ago)
    end

    let(:before_context) do
      received
      sent
    end

    it 'responds with wuis list' do
      expect(response_body.count).to eq 1
      expect(response_body.first['id']).to eq send(wuis_action).id
    end

    it 'includes the expected attributes in the response' do
      expect(response_body.last.keys).to eq ['id',
                                             'wui_type',
                                             'status',
                                             'updated_at',
                                             'vehicle',
                                             'action']

      expect(response_body.first['vehicle'].keys).to eq ['id', 'identifier']
    end

    it 'includes the right action in the response' do
      expect(response_body.first['action']).to eq wuis_action.to_s
    end

    it 'includes the right vehicle in the response' do
      expect(response_body.first).to include 'vehicle'
      expect(response_body.first['vehicle']['id'])
        .to eq send(wuis_action).vehicle.id
    end
  end  
end
