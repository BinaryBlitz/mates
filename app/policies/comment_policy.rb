class CommentPolicy < ApplicationPolicy
  def create?
    record.event.users.include?(user)
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user || record.event.creator == user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
