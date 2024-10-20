# FIXME: Upstream to Rails
Rails.application.config.after_initialize do
  ActionController.add_renderer :svg do |svg, options|
    self.content_type = Mime[:svg] if media_type.nil?
    svg
  end
end
