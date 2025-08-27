class Notification::BundleMailer < ApplicationMailer
  helper NotificationsHelper

  def notification(bundle)
    @bundle = bundle
    @notifications = bundle.notifications

    mail \
      to: bundle.user.email_address,
      subject: "Latest Activity in Fizzy"
  end
end
