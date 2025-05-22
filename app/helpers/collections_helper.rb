module CollectionsHelper
  def collection_auto_close_options
    [
      [ "3 days", 3.days ],
      [ "7 days", 7.days ],
      [ "30 days", 30.days ],
      [ "90 days", 90.days ],
      [ "365 days", 365.days ]
    ]
  end

  def collection_stalled_options
    [
      [ "1 day", 1.days ],
      [ "2 days", 2.days ],
      [ "3 days", 3.days ],
      [ "7 days", 7.days ],
      [ "14 days", 14.days ],
      [ "30 days", 30.days ],
      [ "365 days", 365.days ]
    ]
  end
end
