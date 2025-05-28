module ExcerptHelper
  def format_excerpt(content, length: 200)
    return "" if content.blank?

    text = content.to_plain_text
    text = text.gsub(/^>\s*(.*)$/m, '> \1')
    text = text.gsub(/^[-*]\s*(.*)$/m, '• \1')
    text = text.gsub(/^\d+\.\s*(.*)$/m) { |m| m }
    text = text.gsub(/\s+/, " ").strip
    text.truncate(length)
  end
end
