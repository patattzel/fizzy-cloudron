module Account::Seedeable
  extend ActiveSupport::Concern

  def setup_basic_template
    user = User.first

    Collection.create!(name: "Cards", creator: user, all_access: true)
  end

  def setup_customer_template
    Account::Seeder.new(self, User.active.first).seed
  end
end
