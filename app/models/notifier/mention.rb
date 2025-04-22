class Notifier::Mention < Notifier
  private
    def resource
      source.container
    end

    def recipients
      if source.self_mention?
        []
      else
        [ source.mentionee ]
      end
    end

    def creator
      source.mentioner
    end
end
