class EventPolicy < ApplicationPolicy
  attr_reader :event, :user

  def initialize(user, event)
    @user = user
    @event = event
  end

  def update?
    event.creator == user
  end

  def destroy?
    update?
  end

  def remove?
    update?
  end

  def submissions?
    update?
  end

  def comment?
    event.users.include?(user)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
