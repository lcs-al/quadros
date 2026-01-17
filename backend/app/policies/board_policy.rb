class BoardPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    owner? || member?
  end

  def create?
    true # Any authenticated user can create boards
  end

  def update?
    owner? || editor?
  end

  def destroy?
    owner?
  end

  def manage_members?
    owner?
  end

  private

  def owner?
    record.created_by_id == user.id
  end

  def member?
    record.board_memberships.exists?(user_id: user.id)
  end

  def editor?
    membership = record.board_memberships.find_by(user_id: user.id)
    membership&.editor?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.left_outer_joins(:board_memberships)
           .where(created_by_id: user.id)
           .or(scope.left_outer_joins(:board_memberships).where(board_memberships: { user_id: user.id }))
           .distinct
    end
  end
end

