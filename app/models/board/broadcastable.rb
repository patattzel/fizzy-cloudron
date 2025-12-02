module Board::Broadcastable
  extend ActiveSupport::Concern

  included do
    broadcasts_refreshes
  end
end
