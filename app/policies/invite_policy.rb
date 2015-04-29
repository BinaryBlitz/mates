class InvitePolicy < ApplicationPolicy
  def update?
    record.user == user
  end

  def destroy?
    record.user == user || user == record.event.admin
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
