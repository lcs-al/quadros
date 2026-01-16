class BoardsController < ApplicationController
  before_action :set_board, only: %i[show update destroy]

  def index
    @boards = Board.all
    render json: @boards
  end

  def show
    render json: @board, include: {
      columns: {
        include: {
          cards: {
            include: :assignee
          }
        }
      }
    }
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

