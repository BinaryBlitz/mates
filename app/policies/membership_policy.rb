class MembershipPolicy < ApplicationPolicy
  def initialize(user, membership)
    @user = user
    @membership = membership
    @event = @membership.event
  end

  def create?
    @event.valid_user?(@user)
  end

  def destroy?
    @user == @event.creator || @user == @membership.user
  end
end
