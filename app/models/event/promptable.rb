module Event::Promptable
  extend ActiveSupport::Concern

  def to_prompt
    <<~PROMPT
        ## Event #{action} (#{eventable_type} #{eventable_id}))

        * Created at: #{created_at}
        * Created by: #{creator.name}

        #{eventable.to_prompt}
      PROMPT
  end
end
