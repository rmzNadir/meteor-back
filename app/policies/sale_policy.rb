class SalePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.all if user.admin?

      scope.where(user_id: user.id)
    end
  end
end
