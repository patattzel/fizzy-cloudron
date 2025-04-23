require "test_helper"

class MentionsTest < ActiveSupport::TestCase
  setup do
    Current.session = sessions(:david)
  end

  test "collect mentions on create" do
    assert_difference -> { Mention.count }, +1 do
      perform_enqueued_jobs only: Mention::CreateJob do
        collections(:writebook).cards.create title: "Cleanup", description: "Did you finish up with the cleanup, @david?"
      end
    end
  end

  test "collect mentions on update" do
    assert_difference -> { Mention.count }, +1 do
      perform_enqueued_jobs only: Mention::CreateJob do
        cards(:logo).update! description: "Did you finish up with the cleanup, @david?"
      end
    end
  end
end
