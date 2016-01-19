class Activity
  def initialize(current_user)
    @user = current_user
  end

  def submissions
    @user.submissions.reviewed
  end

  def invites
    @user.invites.reviewed
  end

  def outgoing_friend_requests
    @user.friend_requests.reviewed
  end

  def incoming_friend_requests
    @user.incoming_friend_requests.unreviewed
  end

  def memberships
    Membership.where(event: @user.events).where('created_at > ?', 1.week.ago)
  end
end
