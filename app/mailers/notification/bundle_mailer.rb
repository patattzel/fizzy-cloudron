class Notification::BundleMailer < ApplicationMailer
  def notification(bundle)
    @bundle = bundle
    @notifications = bundle.notifications
    
    mail(
      to: bundle.user.email_address,
      subject: "You have #{@notifications.count} notifications"
    )
  end
end