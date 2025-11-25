require "test_helper"

class ColumnLimitsTest < ActiveSupport::TestCase
  test "account name rejects strings over 255 characters" do
    account = Account.new(name: "a" * 256)
    assert_not account.valid?
    assert_includes account.errors[:name], "is too long (maximum is 255 characters)"
  end

  test "account name accepts strings up to 255 characters" do
    account = Account.new(name: "a" * 255)
    assert account.valid?
    assert_not_includes account.errors[:name], "is too long (maximum is 255 characters)"
  end

  test "account name accepts 255 emoji characters" do
    account = Account.new(name: "🎉" * 255)
    assert account.valid?
    assert_not_includes account.errors[:name], "is too long (maximum is 255 characters)"
  end

  test "account name rejects 256 emoji characters" do
    account = Account.new(name: "🎉" * 256)
    assert_not account.valid?
    assert_includes account.errors[:name], "is too long (maximum is 255 characters)"
  end

  # Test text column limits (65535 bytes for TEXT)
  test "step content rejects text over 65535 bytes" do
    step = Step.new(content: "a" * 65536, card: cards(:logo))
    assert_not step.valid?
    assert_includes step.errors[:content], "is too long (maximum is 65535 bytes)"
  end

  test "step content accepts text up to 65535 bytes" do
    step = Step.new(content: "a" * 65535, card: cards(:logo))
    assert step.valid?
    assert_not_includes step.errors[:content], "is too long (maximum is 65535 bytes)"
  end

  test "step content counts bytes not characters for text columns" do
    # 20000 emoji = 20000 chars but 80000 bytes (over 65535 limit)
    step = Step.new(content: "🎉" * 20000, card: cards(:logo))
    assert_not step.valid?
    assert_includes step.errors[:content], "is too long (maximum is 65535 bytes)"
  end

  # Test ActionText::RichText (inherits from ActionText::Record, not ApplicationRecord)
  test "ActionText::RichText name rejects strings over 255 characters" do
    rich_text = ActionText::RichText.new(name: "a" * 256, record: cards(:logo))
    assert_not rich_text.valid?
    assert_includes rich_text.errors[:name], "is too long (maximum is 255 characters)"
  end

  # Test ActiveStorage::Blob (inherits from ActiveStorage::Record, not ApplicationRecord)
  test "ActiveStorage::Blob filename rejects strings over 255 characters" do
    Current.account = accounts(:"37s")
    blob = ActiveStorage::Blob.new(filename: "a" * 256)
    assert_not blob.valid?
    assert_includes blob.errors[:filename], "is too long (maximum is 255 characters)"
  end
end
