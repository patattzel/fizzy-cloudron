module Attachments
  extend ActiveSupport::Concern

  def attachments
    rich_text_record&.embeds || []
  end

  def has_attachments?
    attachments.any?
  end

  private
    def rich_text_record
      @rich_text_record ||= begin
        association = self.class.reflect_on_all_associations(:has_one).find { it.klass == ActionText::RichText }
        public_send(association.name)
      end
    end
end
