class CreateWebhooks < ActiveRecord::Migration[8.1]
  def change
    create_table :webhooks do |t|
      t.boolean :active, default: true, null: false
      t.string :name
      t.text :url, null: false
      t.text :subscribed_actions
      t.string :signing_secret, null: false

      t.timestamps

      # MySQL requires a prefix length for TEXT column indexes
      t.index "subscribed_actions(255)", name: "index_webhooks_on_subscribed_actions"
    end
  end
end
