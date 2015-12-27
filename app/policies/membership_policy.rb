class MembershipPolicy < ApplicationPolicy
  attr_reader :membership, :user, :event

  def initialize(user, membership)
    @user = user
    @membership = membership
    @event = @membership.event
  end

  def create?
    event.valid_user?(user)
  end

  def destroy?
    not_admin_record = (membership.user != event.creator)
    admin_or_self = (user == event.creator || user == membership.user)
    not_admin_record && admin_or_self
  end
end
