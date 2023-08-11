RSpec.shared_examples 'show invitees' do |is_creator, is_invitee, expected_result|
  before do
    allow(helper).to receive(:current_user_is_creator?).with(event).and_return(is_creator)
  end

  it "returns #{expected_result}" do
    result = helper.show_invitees?(event, is_invitee)
    expect(result).to be(expected_result)
  end
end
