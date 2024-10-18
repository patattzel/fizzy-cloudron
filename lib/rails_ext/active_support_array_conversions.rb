module RailsExt
  module ActiveSupportArrayConversions
    def to_choice_sentence
      to_sentence two_words_connector: " or ", last_word_connector: ", or "
    end
  end
end

Array.include RailsExt::ActiveSupportArrayConversions
