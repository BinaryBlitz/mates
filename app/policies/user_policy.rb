class UserPolicy < ApplicationPolicy
  def update?
    record == user
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
