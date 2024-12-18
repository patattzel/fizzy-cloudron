ActiveSupport.on_load :action_text_markdown do
  require "markdown_renderer"
  require "redcarpet/render_strip"

  ActionText::Markdown.html_renderer = ->(content) { MarkdownRenderer.build.render(content) }
  ActionText::Markdown.plain_text_renderer = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
end
