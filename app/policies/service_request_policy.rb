class ServiceRequestPolicy < ApplicationPolicy
  def show?
    return true if user&.admin? || user&.lawyer?

    record.client_id == user&.id
  end

  def create?
    true
  end

  def update?
    user&.admin? || user&.lawyer? || record.client_id == user&.id
  end

  def transition?
    user&.admin? || user&.lawyer?
  end

  class Scope < Scope
    def resolve
      return scope.all if user&.admin? || user&.lawyer?
      return scope.where(client_id: user.id) if user.present?

      scope.none
    end
  end
end
