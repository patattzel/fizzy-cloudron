#!/usr/bin/env ruby

require_relative "../config/environment"

if ARGV.length < 2
  puts "Usage: #{$0} <email> <tenant>"
  exit 1
end

email_address = ARGV[0]
tenant = ARGV[1]

def confirm(noun)
  print "Is this the correct #{noun}? (y/n) "
  response = $stdin.gets.chomp.downcase
  exit 0 unless response == "y"
  puts
end

signal_identity = SignalId::Identity.find_by!(email_address: email_address)
pp signal_identity
confirm "identity"

ApplicationRecord.with_tenant(tenant) do
  signal_account = Account.sole.signal_account
  pp signal_account
  confirm "account"

  SignalId::Database.on_master do
    signal_user = SignalId::User.create!(identity: signal_identity, account: signal_account)

    user = User.create!(
      name:           signal_user.name,
      email_address:  signal_user.email_address,
      signal_user_id: signal_user.id,
      password:       SecureRandom.hex(36) # TODO: remove password column?
    )

    puts "Created: "
    pp [ user, signal_user ]
  end
end
