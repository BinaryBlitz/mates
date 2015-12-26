class EventPolicy < ApplicationPolicy
  def update?
    record.creator == user
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

  def submissions?
    update?
  end

  def leave?
    record.creator != user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
