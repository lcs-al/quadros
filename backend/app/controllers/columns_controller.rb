class ColumnsController < ApplicationController
  before_action :set_board
  before_action :set_column, only: %i[update destroy move]

  def create
    @column = @board.columns.build(column_params)
    if @column.save
      render json: @column, status: :created
    else
      render json: @column.errors, status: :unprocessable_entity
    end
  end

  def update
    if @column.update(column_params)
      render json: @column
    else
      render json: @column.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @column.destroy
  end

  def move
    @column.insert_at(params[:position].to_i)
    render json: @column
  end

  private

  def set_board
    @board = Board.find(params[:board_id])
  end

  def set_column
    @column = @board.columns.find(params[:id])
  end

  def column_params
    params.require(:column).permit(:title)
  end
end

