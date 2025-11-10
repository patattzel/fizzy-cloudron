class Card::AutoPostponeAllDueJob < ApplicationJob
  def perform
    Card.auto_postpone_all_due
  end
end
