class InvitePolicy < ApplicationPolicy
  attr_reader :user, :invite, :event

  def initialize(user, invite)
    @user = user
    @invite = invite
    @event = @invite.event
  end

  def create?
    user == event.creator || event.users.include?(user)
  end

  def update?
    invite.user == user
  end

  def destroy?
    user == invite.event.creator
  end

  def decline?
    invite.user == user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
