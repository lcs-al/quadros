class BoardMembershipsController < ApplicationController
  before_action :set_board
  before_action :authorize_board

  def index
    memberships = @board.board_memberships.includes(:user)
    render json: memberships, include: { user: { methods: [:avatar_url] } }
  end

  def create
    user = User.find_by(email: membership_params[:email])

    if user.nil?
      render json: { error: 'User not found' }, status: :not_found
      return
    end

    if @board.owner?(user)
      render json: { error: 'Cannot add owner as member' }, status: :unprocessable_entity
      return
    end

    membership = @board.board_memberships.build(
      user: user,
      role: membership_params[:role] || 'viewer'
    )

    if membership.save
      render json: membership, include: { user: { methods: [:avatar_url] } }, status: :created
    else
      render json: membership.errors, status: :unprocessable_entity
    end
  end

  def update
    membership = @board.board_memberships.find(params[:id])

    if membership.update(role: membership_params[:role])
      render json: membership, include: { user: { methods: [:avatar_url] } }
    else
      render json: membership.errors, status: :unprocessable_entity
    end
  end

  def destroy
    membership = @board.board_memberships.find(params[:id])
    membership.destroy
    head :no_content
  end

  private

  def set_board
    @board = Board.find(params[:board_id])
  end

  def authorize_board
    authorize @board, :manage_members?
  end

  def membership_params
    params.require(:membership).permit(:email, :role)
  end
end
