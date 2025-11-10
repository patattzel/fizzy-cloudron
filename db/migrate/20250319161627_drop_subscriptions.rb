class DropSubscriptions < ActiveRecord::Migration[8.1]
  def change
    execute "
      update accesses set involvement = 'access_only'
    "
    # MySQL uses JOIN syntax for multi-table updates
    execute "
      update accesses
      join (select user_id, subscribable_id as bucket_id from subscriptions) as subscriptions
        on subscriptions.user_id = accesses.user_id and subscriptions.bucket_id = accesses.bucket_id
      set accesses.involvement = 'watching'
    "

    drop_table :subscriptions
  end
end
