module CollectionsHelper
  def collection_auto_close_options
    [
      [ "3 days", 3.days ],
      [ "1 week", 7.days ],
      [ "1 month", 30.days ],
      [ "90 days", 90.days ],
      [ "1 year", 365.days ]
    ]
  end

  def collection_stalled_options
    [
      [ "1 day", 1.days ],
      [ "2 days", 2.days ],
      [ "3 days", 3.days ],
      [ "1 week", 7.days ],
      [ "2 weeks", 14.days ],
      [ "1 month", 30.days ],
      [ "1 year", 365.days ]
    ]
  end
end
