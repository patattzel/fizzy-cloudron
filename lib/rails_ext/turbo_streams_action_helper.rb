module TurboStreamsActionsHelper
  def set_css_variable(target, name:, value:)
    tag.turbo_stream target: target, action: "set_css_variable", name:, value:
  end
end

Turbo::Streams::TagBuilder.prepend(TurboStreamsActionsHelper)
