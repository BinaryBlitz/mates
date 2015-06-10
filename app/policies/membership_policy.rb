class MembershipPolicy < ApplicationPolicy
  def create?
    record.event.valid_user?(user)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
