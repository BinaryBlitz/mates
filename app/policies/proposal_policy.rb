class ProposalPolicy < ApplicationPolicy
  def update?
    user == record.user
  end

  def destroy?
    user == record.user || user == record.event.admin
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
