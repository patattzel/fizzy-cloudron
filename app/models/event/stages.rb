module Event::Stages
  extend ActiveSupport::Concern

  included do
    store_accessor :particulars, :stage_id
  end

  def stage
    @stage ||= account.stages.find_by_id stage_id
  end
end
