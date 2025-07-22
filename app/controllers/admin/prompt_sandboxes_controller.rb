class Admin::PromptSandboxesController < AdminController
  include DayTimelinesScoped

  def show
    @prompt = cookies[:prompt].presence || Event::Summarizer::PROMPT
    @summary, @summarizable_content = summarize(@day_timeline, @prompt)
  end

  def create
    @prompt = params[:prompt]
    cookies[:prompt] = @prompt
    @summary, @summarizable_content = summarize(@day_timeline, @prompt)
    redirect_to admin_prompt_sandbox_path(day: @day_timeline.day)
  end

  private
    def summarize(day_timeline, prompt)
      summarizer = Event::Summarizer.new(day_timeline.events, prompt: prompt)
      summary = summarizer.summarize
      activity_summary = Event::ActivitySummary.new(content: summary)
      [ activity_summary.to_html, summarizer.summarizable_content.html_safe ]
    end
end
