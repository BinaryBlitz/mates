class SubmissionPolicy < ApplicationPolicy
  def index?
    user == record.creator
  end

  def update?
    user == record.event.creator
  end

  def destroy?
    user == record.user || user == record.event.creator
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
