RSpec.shared_examples 'invitation status' do |expired, expected_result|
  before do
    create(:invitation, recipient: user, event:, expired:)
  end

  it "returns #{expected_result}" do
    result = helper.invited?(event)
    expect(result).to be(expected_result)
  end
end
