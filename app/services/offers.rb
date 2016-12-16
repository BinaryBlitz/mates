class Offers
  attr_reader :outgoing_invites, :outgoing_submissions, :incoming_invites, :incoming_submissions

  def initialize(user)
    @user = user
    build
  end

  def number_of_unreviewed
    (outgoing_invites + outgoing_submissions + incoming_invites + incoming_submissions).count
  end

  private

  def build
    build_invites
    build_submissions
  end

  def build_invites
    @outgoing_invites = Invite.where(event: @user.owned_events).unreviewed.includes(:event, :user)
    @incoming_invites = @user.invites.unreviewed.includes(:event, :user)
  end

  def build_submissions
    @outgoing_submissions = @user.submissions.unreviewed.includes(:event, :user)
    @incoming_submissions = Submission.where(event: @user.owned_events).unreviewed.includes(:event, :user)
  end
end
