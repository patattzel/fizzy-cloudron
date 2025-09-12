require "test_helper"

class WebhooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "index" do
    get webhooks_path
    assert_response :success
  end

  test "show" do
    webhook = webhooks(:active)
    get webhook_path(webhook)
    assert_response :success
  end

  test "new" do
    get new_webhook_path
    assert_response :success
    assert_select "form"
  end

  test "create with valid params" do
    assert_difference "Webhook.count", 1 do
      post webhooks_path, params: {
        webhook: {
          name: "Test Webhook",
          url: "https://example.com/webhook",
          subscribed_actions: [ "", "card_created", "card_closed" ]
        }
      }
    end

    webhook = Webhook.order(id: :desc).first

    assert_redirected_to webhook_path(webhook)
    assert_equal "Test Webhook", webhook.name
    assert_equal "https://example.com/webhook", webhook.url
    assert_equal [ "card_created", "card_closed" ], webhook.subscribed_actions
  end

  test "create with invalid params" do
    assert_no_difference "Webhook.count" do
      post webhooks_path, params: {
        webhook: {
          name: "",
          url: "invalid-url"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select "form"
  end

  test "edit" do
    webhook = webhooks(:active)
    get edit_webhook_path(webhook)
    assert_response :success
    assert_select "form"
  end

  test "update with valid params" do
    webhook = webhooks(:active)
    patch webhook_path(webhook), params: {
      webhook: {
        name: "Updated Webhook",
        subscribed_actions: [ "card_created" ]
      }
    }

    webhook.reload

    assert_redirected_to webhook_path(webhook)
    assert_equal "Updated Webhook", webhook.name
    assert_equal [ "card_created" ], webhook.subscribed_actions
  end

  test "update with invalid params" do
    webhook = webhooks(:active)
    patch webhook_path(webhook), params: {
      webhook: {
        name: ""
      }
    }

    assert_response :unprocessable_entity
    assert_select "form"

    assert_no_changes -> { webhook.reload.url } do
      patch webhook_path(webhook), params: {
        webhook: {
          name: "Updated Webhook",
          url: "https://different.com/webhook"
        }
      }
    end

    assert_redirected_to webhook_path(webhook)
  end

  test "destroy" do
    webhook = webhooks(:active)

    assert_difference "Webhook.count", -1 do
      delete webhook_path(webhook)
    end

    assert_redirected_to webhooks_path
  end
end
