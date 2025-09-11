require "test_helper"

class WebhookTest < ActiveSupport::TestCase
  test "create" do
    webhook = Webhook.create! name: "Test", url: "https://example.com/webhook"
    assert webhook.persisted?
    assert webhook.active?
    assert webhook.signing_secret.present?
    assert webhook.delinquency_tracker.present?
  end

  test "validates the url" do
    webhook = Webhook.new name: "Test"
    assert_not webhook.valid?
    assert_includes webhook.errors[:url], "not a URL"

    webhook = Webhook.new name: "Test", url: "not a url"
    assert_not webhook.valid?
    assert_includes webhook.errors[:url], "not a URL"

    webhook = Webhook.new name: "NOTHING", url: "example.com/webhook"
    assert_not webhook.valid?
    assert_includes webhook.errors[:url], "must use http or https"

    webhook = Webhook.new name: "BLANK", url: "//example.com/webhook"
    assert_not webhook.valid?
    assert_includes webhook.errors[:url], "must use http or https"

    webhook = Webhook.new name: "GOPHER", url: "gopher://example.com/webhook"
    assert_not webhook.valid?
    assert_includes webhook.errors[:url], "must use http or https"

    webhook = Webhook.new name: "HTTP", url: "http://example.com/webhook"
    assert webhook.valid?

    webhook = Webhook.new name: "HTTPS", url: "https://example.com/webhook"
    assert webhook.valid?
  end

  test "deactivate" do
    webhook = webhooks(:active)

    assert_changes -> { webhook.active? }, from: true, to: false do
      webhook.deactivate
    end
  end

  test "activate" do
    webhook = webhooks(:inactive)

    assert_changes -> { webhook.active? }, from: false, to: true do
      webhook.activate
    end
  end
end
