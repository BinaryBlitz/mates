class CommentPolicy < ApplicationPolicy
  def update?
    record.user == user
  end

  def destroy?
    record.user == user || record.event.admin == user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
