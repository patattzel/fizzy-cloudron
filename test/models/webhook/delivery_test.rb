require "test_helper"

class Webhook::DeliveryTest < ActiveSupport::TestCase
  test "create" do
    webhook = webhooks(:active)
    event = events(:layout_commented)
    delivery = Webhook::Delivery.create!(webhook: webhook, event: event)

    assert_equal "pending", delivery.state
  end

  test "succeeded" do
    webhook = webhooks(:active)
    event = events(:layout_commented)
    delivery = Webhook::Delivery.new(
      webhook: webhook,
      event: event,
      response: { code: 200 },
      state: :completed
    )
    assert delivery.succeeded?

    delivery.response[:code] = 422
    assert_not delivery.succeeded?, "resonse must have a 2XX status"

    delivery.response[:code] = 200
    delivery.state = :pending
    assert_not delivery.succeeded?, "state must be completed"

    delivery.state = :in_progress
    assert_not delivery.succeeded?, "state must be completed"

    delivery.state = :errored
    assert_not delivery.succeeded?, "state must be completed"

    delivery.state = :completed
    delivery.response[:error] = :destination_unreachable

    assert_not delivery.succeeded?, "the response can't have an error"
  end

  test "deliver_later" do
    delivery = webhook_deliveries(:pending)

    assert_enqueued_with job: Webhook::DeliveryJob, args: [ delivery ] do
      delivery.deliver_later
    end
  end

  test "deliver" do
    delivery = webhook_deliveries(:pending)

    stub_request(:post, delivery.webhook.url)
      .to_return(status: 200, headers: { "content-type" => "application/json", "x-test" => "foo" })

    assert_equal "pending", delivery.state

    tracker = delivery.webhook.delinquency_tracker
    assert_difference -> { tracker.reload.total_count }, 1 do
      delivery.deliver
    end

    assert delivery.persisted?
    assert_equal "completed", delivery.state
    assert delivery.request[:headers].present?
    assert_equal [ "foo" ], delivery.response[:headers]["x-test"]
    assert_equal 200, delivery.response[:code]
    assert delivery.response[:error].blank?
  end

  test "deliver when the network timeouts" do
    delivery = webhook_deliveries(:pending)
    stub_request(:post, delivery.webhook.url).to_timeout

    delivery.deliver

    assert_equal "completed", delivery.state
    assert_equal "connection_timeout", delivery.response[:error]
  end

  test "deliver when the connection is refused" do
    delivery = webhook_deliveries(:pending)
    stub_request(:post, delivery.webhook.url).to_raise(Errno::ECONNREFUSED)

    delivery.deliver

    assert_equal "completed", delivery.state
    assert_equal "destination_unreachable", delivery.response[:error]
  end

  test "deliver when an SSL error occurs" do
    delivery = webhook_deliveries(:pending)
    stub_request(:post, delivery.webhook.url).to_raise(OpenSSL::SSL::SSLError)

    delivery.deliver

    assert_equal "completed", delivery.state
    assert_equal "failed_tls", delivery.response[:error]
  end

  test "deliver when an unexpected error occurs" do
    delivery = webhook_deliveries(:pending)
    stub_request(:post, delivery.webhook.url).to_raise(StandardError, "Unexpected error")

    assert_raises(StandardError) do
      delivery.deliver
    end

    assert_equal "errored", delivery.state
  end
end
