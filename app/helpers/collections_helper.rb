module CollectionsHelper
  def collection_auto_close_options
    [
      [ "3", 3.days ],
      [ "7", 7.days ],
      [ "11", 11.days ],
      [ "30", 30.days ],
      [ "90", 90.days ],
      [ "365", 365.days ]
    ]
  end
end
