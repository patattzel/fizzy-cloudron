# Enable autotuner. Alternatively, call Autotuner.sample_ratio= with a value
# between 0 and 1.0 to sample on a portion of instances.
Autotuner.enabled = true

# This callback is called whenever a suggestion is provided by this gem.
# You can output this report to your logging pipeline, stdout, a file,
# or somewhere else!
Autotuner.reporter = proc do |report|
  Rails.logger.info "GCAUTOTUNE: #{report}"

  if Fizzy.saas?
    Sentry.capture_message "Autotuner suggestion", level: :info, extra: { report: report.to_s }
  end
end
