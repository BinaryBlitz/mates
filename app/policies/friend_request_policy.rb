class FriendRequestPolicy < ApplicationPolicy
  def update?
    record.friend == user
  end

  def destroy?
    user == record.friend || user == record.user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
