class Event::Summarizer
  include Ai::Prompts
  include Rails.application.routes.url_helpers

  attr_reader :events

  MAX_WORDS = 120

  LLM_MODEL = "chatgpt-4o-latest"

  PROMPT = <<~PROMPT
    Help me make sense of what happened today in a 10 second read. Help me see patterns or things I might not be able to put together by looking at each individual entry. Write a bold headline for each. No more than 5.

    This is a great example:
    **Mobile UX dominated the day**. Several issues were raised and addressed around mobile usability — from notification stack clutter and filter visibility, to workflow controls and truncated content.
  PROMPT

  def initialize(events, prompt: PROMPT, llm_model: LLM_MODEL)
    @events = events
    @prompt = prompt
    @llm_model = llm_model
  end

  def summarize
    response = chat.ask join_prompts("Summarize the following content:", summarizable_content)
    response.content
  end

  def summarizable_content
    join_prompts events.collect(&:to_prompt)
  end

  private
    attr_reader :prompt, :llm_model

    def chat
      chat = RubyLLM.chat(model: llm_model)
      chat.with_instructions(join_prompts(prompt, domain_model_prompt, user_data_injection_prompt))
    end
end
