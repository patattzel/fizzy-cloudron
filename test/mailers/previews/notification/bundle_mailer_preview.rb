class Notification::BundleMailerPreview < ActionMailer::Preview
  def notification
    bundle = Notification::Bundle.all.sample

    Notification::BundleMailer.notification bundle
  end
end
