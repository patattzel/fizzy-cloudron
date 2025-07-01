module RichTextHelper
  def mentions_prompt(collection)
    content_tag "lexical-prompt", "", trigger: "@", src: prompts_collection_users_path(collection), name: "mention"
  end

  def global_mentions_prompt
    content_tag "lexical-prompt", "", trigger: "@", src: prompts_users_path, name: "mention"
  end

  def tags_prompt
    content_tag "lexical-prompt", "", trigger: "#", src: prompts_tags_path, name: "tag"
  end

  def cards_prompt
    content_tag "lexical-prompt", "", trigger: "#", src: prompts_cards_path, name: "card", "insert-editable-text": true, "remote-filtering": true
  end
end
