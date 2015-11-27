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
      vehicle = create(:vehicle, user: current_owner)

      create(:wui,
             user: sender,
             vehicle_identifier: vehicle.identifier,
             updated_at: 2.minutes.ago)
    end

    let(:sent) do
      receiver = create(:user)
      vehicle = create(:vehicle, user: receiver)

      create(:wui,
             user: current_owner,
             vehicle_identifier: vehicle.identifier,
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
                                             'vehicle_identifier',
                                             'latitude',
                                             'longitude']
    end

    it 'includes the right vehicle in the response' do
      expect(response_body.first['vehicle_identifier'])
        .to eq send(wuis_action).vehicle_identifier
    end

    it 'responds with pagination' do
      expect(response.headers.keys).to include 'Per-Page'
      expect(response.headers.keys).to include 'Total'
    end
  end  
end
