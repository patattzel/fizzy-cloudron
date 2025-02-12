class FirstRun
  def self.create!(user_attributes)
    account = Account.create!(name: "Fizzy")
    account.users.member.create!(user_attributes)
  end
end
