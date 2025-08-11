class Ai::Tool < RubyLLM::Tool
  include Rails.application.routes.url_helpers

  private
    def default_url_options
      Rails.application.default_url_options
        .reverse_merge(host: "fizzy.localhost", port: 3006)
        .merge(script_name: "/#{ApplicationRecord.current_tenant}")
    end
end
