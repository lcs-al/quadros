namespace :cleanup do
  desc "Hard delete cards soft-deleted for more than 1 day"
  task hard_delete_cards: :environment do
    HardDeleteCardsJob.perform_now
  end

end
