require "test_helper"

class Conversation::MessageTest < ActiveSupport::TestCase
  test "emoji content" do
    message = Conversation::Message.new(content: "Hello 😊")
    assert_not message.all_emoji?, "Message with mixed content should not be all emoji"

    message.content = "😊"
    assert message.all_emoji?, "Message with only emoji should be recognized as all emoji"
  end
end
