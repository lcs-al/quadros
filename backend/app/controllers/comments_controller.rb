class CommentsController < ApplicationController
  before_action :set_card
  before_action :set_comment, only: %i[update destroy]

  def create
    @comment = @card.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
  end

  private

  def set_card
    @card = Card.find(params[:card_id])
  end

  def set_comment
    @comment = @card.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
