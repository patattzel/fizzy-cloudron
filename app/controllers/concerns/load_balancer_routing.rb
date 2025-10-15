module LoadBalancerRouting
  extend ActiveSupport::Concern

  ALLOWED_PRAGMAS = %w[ beamer_primary beamer_last_txn ]

  included do
    before_action :set_target_header, :set_writer_header
    after_action :set_transaction_cookie
  end

  private
    def set_target_header
        response.headers["X-Kamal-Target"] = request.headers["X-Kamal-Target"]
    end

    def set_writer_header
      if ApplicationRecord.current_tenant.present?
        response.headers["X-Writer"] = pragma("beamer_primary")
      end
    end

    def set_transaction_cookie
      unless safe_request?
        if ApplicationRecord.current_tenant.present? && Account.sole.present?
          cookies[:last_transaction] = { value: pragma("beamer_last_txn"), path: Account.sole.slug }
        end
      end
    end

    def pragma(name)
      if ALLOWED_PRAGMAS.include?(name)
        ApplicationRecord.connection.execute("pragma #{name}").first&.values&.first
      end
    end

    def safe_request?
      request.get? || request.head?
    end
end
