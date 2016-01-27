class FriendRequestPolicy < ApplicationPolicy
  def update?
    record.friend == user
  end

  def destroy?
    user == record.user
  end

  def decline?
    user == record.friend
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
