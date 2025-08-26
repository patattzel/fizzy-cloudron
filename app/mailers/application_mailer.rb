class ApplicationMailer < ActionMailer::Base
  default from: "The Fizzy team <support@#{Rails.application.config.hosts.first}>"

  layout "mailer"
  append_view_path Rails.root.join("app/views/mailers")
  helper AvatarsHelper, HtmlHelper
end
