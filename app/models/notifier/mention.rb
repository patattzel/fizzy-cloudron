class Notifier::Mention < Notifier
  private
    def resource
      source.container
    end

    def recipients
      [ source.mentionee ]
    end
end
