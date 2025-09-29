class Card::AutoPostponeAllDueJob < ApplicationJob
  def perform
    ApplicationRecord.with_each_tenant do |tenant|
      Card.auto_postpone_all_due
    end
  end
end
