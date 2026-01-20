class BacklogsController < ApplicationController
  before_action :set_board
  before_action :set_backlog

  def show
    authorize @board, policy_class: BoardPolicy
    render json: @backlog, include: {
      cards: {
        include: [:assignee, :creator]
      }
    }
  end

  private

  def set_board
    @board = Board.find(params[:board_id])
  end

  def set_backlog
    @backlog = @board.backlog || @board.create_backlog
  end
end
