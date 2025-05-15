RubyLLM.configure do |config|
  config.openai_api_key = Rails.application.credentials.openai_api_key
  config.default_model = "gpt-4.1-nano"
end
