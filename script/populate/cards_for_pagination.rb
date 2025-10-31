require_relative "../../config/environment"

CARDS_COUNT = 10_000

# 37signals seed
ApplicationRecord.current_tenant = "897362094"
Current.session = Session.first
collection = Collection.first

CARDS_COUNT.times do |index|
  card = collection.cards.create!(title: "Card #{index}", status: :published)
  print "."
end
