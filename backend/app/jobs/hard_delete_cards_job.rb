class HardDeleteCardsJob < ApplicationJob
  queue_as :default

  def perform
    Card.unscoped.where('deleted_at < ?', 1.day.ago).destroy_all
  end
end
