module Account::Seedeable
  extend ActiveSupport::Concern

  def setup_customer_template
    Account::Seeder.new(self, users.active.order(created_at: :asc).first).seed
  end
end
