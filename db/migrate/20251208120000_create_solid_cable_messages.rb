class CreateSolidCableMessages < ActiveRecord::Migration[7.2]
  def change
    # Solid Cable stores Action Cable messages here. Some environments may skip the
    # separate cable schema tasks, so we ensure the table exists in the primary DB.
    create_table :solid_cable_messages, id: false do |t|
      t.binary  :channel,      limit: 1024, null: false
      t.bigint  :channel_hash,             null: false
      t.datetime :created_at,              null: false
      t.binary  :payload, size: :long,     null: false
    end

    add_index :solid_cable_messages, :channel,       name: "index_solid_cable_messages_on_channel"
    add_index :solid_cable_messages, :channel_hash,  name: "index_solid_cable_messages_on_channel_hash"
    add_index :solid_cable_messages, :created_at,    name: "index_solid_cable_messages_on_created_at"
  end
end
