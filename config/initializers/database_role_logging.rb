class DatabaseRoleLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    Rails.logger.tagged(ActiveRecord::Base.current_role.to_s) do
      @app.call(env)
    end
  end
end

Rails.application.config.middleware.insert_after ActiveRecord::Middleware::DatabaseSelector, DatabaseRoleLogger
