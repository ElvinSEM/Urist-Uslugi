class ServicePolicy < ApplicationPolicy
  def create?
    user&.admin?
  end

  def update?
    user&.admin?
  end

  def destroy?
    user&.admin?
  end

  class Scope < Scope
    def resolve
      return scope.all if user&.admin? || user&.lawyer?

      scope.published
    end
  end
end
