module Services
  HAS_ACTIVE_INVITATION_ERROR        = "The user has already been invited to this event".freeze
  INVITATION_CREATION_ERROR          = "Invitation could not be created".freeze
  INVITATION_MAILER_ERROR            = "There invitation mailer could not be sent".freeze
  DISABLE_INVITATION_JOB_ERROR       = "The job to disable the invitation could not be enqueued".freeze

  class HasActiveInvitationError < StandardError; end
  class InvitationCreationError < StandardError; end
  class InvitationMailerError < StandardError; end
  class DisableInvitationJobError < StandardError; end
  class InviteeNotFoundError < StandardError; end

  class InvitationService
    include Utils::ErrorHandler

    def initialize(event, invitee_emails)
      @event = event
      @invitee_emails = invitee_emails
      @invitation_errors = 0
    end

    def call
      invitees.each do |invitee|
        process_invitee(invitee)
      rescue HasActiveInvitationError, InvitationCreationError, InvitationMailerError, DisableInvitationJobError => e
        logger.error("#{e.class.name.demodulize} - Error processing invitation for #{invitee.email}: #{e.message}")
        @invitation_errors += 1
      rescue StandardError => e
        logger.error("Error processing invitation for #{invitee.email}: #{e.message}")
        @invitation_errors += 1
      end

      logger.info("#{@invitation_errors} invitations have thrown an error.")
    end

    private

    def invitees
      invitees = @invitee_emails.split(',').map(&:strip).map do |email|
        invitee = User.find_by(email:)
        raise InviteeNotFoundError, "User with email #{email} not found" unless invitee

        invitee
      rescue InviteeNotFoundError => e
        logger.error("#{e.class.name.demodulize} - Error processing an invitation: #{e.message}")
        @invitation_errors += 1
        next
      end

      invitees.compact
    end

    def process_invitee(invitee)
      raise HasActiveInvitationError, HAS_ACTIVE_INVITATION_ERROR if active_invitations?(invitee)

      invitation = create_invitation(invitee)

      unless invitation.save
        raise InvitationCreationError, "#{INVITATION_CREATION_ERROR}: #{invitation.errors.full_messages.join(', ')}"
      end

      send_invitation_email(invitee, invitation)
      enqueue_disable_invitation_job(invitation)
    end

    def active_invitations?(user)
      user.received_invitations.where(event: @event).any?
    end

    def create_invitation(invitee)
      Invitation.new(
        event: @event,
        recipient: invitee,
        sender: @event.creator,
        url: "#{ENV.fetch('APP_URL', 'http://localhost:3000')}/events/#{@event.id}"
      )
    end

    def send_invitation_email(invitee, invitation)
      EventInvitationMailer.with(recipient: invitee, sender: @event.creator,
                                 url: invitation.url).send_invitation.deliver_later
    rescue StandardError => e
      raise InvitationMailerError, "#{INVITATION_MAILER_ERROR}: #{e}"
    end

    def enqueue_disable_invitation_job(invitation)
      DisableInvitationJob.set(wait: 1.day).perform_later(invitation:)
    rescue StandardError => e
      raise DisableInvitationJobError, "#{DISABLE_INVITATION_JOB_ERROR}: #{e}"
    end
  end
end
