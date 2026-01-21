class BoardsController < ApplicationController
  before_action :set_board, only: %i[show update destroy]

  def index
    @boards = policy_scope(Board)
    render json: @boards, include: :created_by
  end

  def show
    authorize @board
    render json: @board.as_json(include: {
      columns: {
        include: {
          cards: {
            include: {
              assignee: { 
                methods: [:avatar_url]
              }
            }
          }
        }
      },
      created_by: { only: [:id, :name, :email], methods: [:avatar_url] },
      board_memberships: { include: { user: { only: [:id, :name, :email], methods: [:avatar_url] } } },
      backlog: { only: [:id] }
    }).merge(
      current_user_role: @board.permission_level(current_user),
      members: @board.members.map { |m| m.as_json(only: [:id, :name, :email], methods: [:avatar_url]) }
    )
  end

  def create
    @board = current_user.boards.build(board_params)
    if @board.save
      render json: @board, status: :created
    else
      render json: @board.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @board
    if @board.update(board_params)
      render json: @board
    else
      render json: @board.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @board
    @board.destroy
  end


  private

  def set_board
    @board = Board.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:title)
  end
end

