class AddUniqueConstraintOnIdentityIdAndTenantToMemberships < ActiveRecord::Migration[8.2]
  def change
    # Remove duplicates, keeping the youngest membership for each identity_id + tenant combination
    # MySQL doesn't allow referencing the target table in a subquery, so we use a JOIN approach
    execute <<-SQL
      DELETE m1 FROM memberships m1
      LEFT JOIN (
        SELECT MAX(id) as max_id
        FROM memberships
        GROUP BY identity_id, tenant
      ) m2 ON m1.id = m2.max_id
      WHERE m2.max_id IS NULL
    SQL

    add_index :memberships, %i[ tenant identity_id ], unique: true
  end
end
