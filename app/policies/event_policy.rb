class EventPolicy < ApplicationPolicy
  def update?
    record.admin == user
  end

  def destroy?
    update?
  end

  def remove?
    update?
  end

  def proposals?
    update?
  end

  def leave?
    record.admin != user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
