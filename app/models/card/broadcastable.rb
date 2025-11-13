module Card::Broadcastable
  extend ActiveSupport::Concern

  included do
    # TODO: Temporarily disabled as I need to handle a couple of additional cases
    #
    # broadcasts_refreshes
  end
end
