require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  let(:user) { create :user }
  let(:event) { create :event }

  describe '#invited?' do
    before do
      sign_in user
    end

    context 'when the user has a non-expired invitation for the event' do
      include_examples 'invitation status', false, true
    end

    context 'when the user has an expired invitation for the event' do
      include_examples 'invitation status', true, false
    end

    context 'when the user does not have an invitation for the event' do
      it 'returns false' do
        result = helper.invited?(event)
        expect(result).to be(false)
      end
    end
  end
end
