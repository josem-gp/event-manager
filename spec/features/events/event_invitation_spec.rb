require 'rails_helper'

RSpec.feature 'Event Invitations', type: :feature do
  let(:user) { create(:user) }
  let(:invited_user) { create(:user) }
  let(:event) { create(:event, creator: user) }

  context 'when user is not invited' do
    before do
      login_as(invited_user)
      visit event_path(event)
    end

    scenario 'User cannot see events details on event page' do
      expect(page).to have_content("Number of invitees")
      expect(page).to_not have_content("Invitee:")
    end
  end

  context 'when user is invited' do
    before do
      create(:invitation, sender: user, event:, recipient: invited_user)
      login_as(invited_user)
      visit event_path(event)
    end

    context 'when user is invited but did not accept invitation' do
      scenario 'User can see invitation details on event page' do
        expect(page).to have_content("Number of invitees")
        expect(page).to_not have_content("Invitee:")
        expect(page).to have_content("Accept")
        expect(page).to have_content("Reject")
      end
    end

    context 'when user is invited and they accept invitation' do
      scenario 'User can see invitation details on event page' do
        expect(page).to have_content("Number of invitees")
        expect(page).to_not have_content("Invitee:")

        click_button 'Accept'

        expect(page).to have_content("Invitation accepted")
        expect(page).to_not have_content("Number of invitees")
        expect(page).to have_content("Invitee: #{invited_user.first_name} #{invited_user.last_name}")
      end
    end

    context 'when user is invited and they reject invitation' do
      scenario 'User cannot see invitation details on event page' do
        expect(page).to have_content("Number of invitees")
        expect(page).to_not have_content("Invitee:")

        click_button 'Reject'

        expect(page).to have_content("Invitation denied")
        expect(page).to have_content("Number of invitees")
        expect(page).to_not have_content("Invitee:")
      end
    end
  end
end
