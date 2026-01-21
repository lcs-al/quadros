class CardsController < ApplicationController
  before_action :set_card, only: %i[show update destroy move]

  def create
    if params[:column_id]
      @container = Column.find(params[:column_id])
    elsif params[:backlog_id]
      @container = Backlog.find(params[:backlog_id])
    end

    @card = @container.cards.build(card_params)
    @card.creator = current_user
    @card.assignee = current_user if card_params[:assignee_id].blank?
    
    if @card.save
      render json: @card, status: :created
    else
      render json: @card.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @card, include: {
      assignee: {},
      creator: {},
      comments: {
        include: :user
      }
    }
  end

  def update
    if @card.update(card_params)
      render json: @card, include: {
        assignee: {},
        creator: {},
        comments: {
          include: :user
        }
      }
    else
      render json: @card.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @card.soft_delete
    head :no_content
  end

  def restore
    @card = Card.unscoped.find(params[:id])
    @card.restore
    render json: @card
  end

  def move
    # Move between containers (columns or backlog)
    board = @card.column&.board || @card.backlog&.board
    authorize board, :update?, policy_class: BoardPolicy

    new_column_id = params[:column_id]
    new_backlog_id = params[:backlog_id]

    if new_column_id && @card.column_id != new_column_id.to_i
      @card.remove_from_list
      @card.backlog_id = nil
      @card.column_id = new_column_id
      @card.save!
      @card.insert_at(params[:position].to_i)
    elsif new_backlog_id && @card.backlog_id != new_backlog_id.to_i
      @card.remove_from_list
      @card.column_id = nil
      @card.backlog_id = new_backlog_id
      @card.save!
      @card.insert_at(params[:position].to_i)
    else
      @card.insert_at(params[:position].to_i)
    end
    render json: @card
  end

  def bulk_move
    card_ids = params[:card_ids]
    new_column_id = params[:column_id]
    new_backlog_id = params[:backlog_id]
    position = params[:position].to_i

    @cards = Card.where(id: card_ids)
    return render json: { error: 'No cards found' }, status: :not_found if @cards.empty?

    # All cards must belong to the same board for simplicity of authorization
    board = @cards.first.column&.board || @cards.first.backlog&.board
    authorize board, :update?, policy_class: BoardPolicy if board

    ActiveRecord::Base.transaction do
      @cards.each do |card|
        if new_column_id && card.column_id != new_column_id.to_i
          card.remove_from_list
          card.backlog_id = nil
          card.column_id = new_column_id
          card.save!
          card.insert_at(position)
        elsif new_backlog_id && card.backlog_id != new_backlog_id.to_i
          card.remove_from_list
          card.column_id = nil
          card.backlog_id = new_backlog_id
          card.save!
          card.insert_at(position)
        end
      end
    end

    render json: { success: true, count: @cards.count }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def set_card
    @card = Card.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:title, :description, :assignee_id, :column_id, :backlog_id, :card_type, :priority, :story_points, :due_date, labels: [])
  end
end

