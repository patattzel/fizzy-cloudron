module CollectionsHelper
  def collection_auto_close_options
    [
      [ "7 days", 7.days ],
      [ "30 days", 30.days ],
      [ "90 days", 90.days ],
      [ "Never", nil ]
    ]
  end

  def collection_stalled_options
    [
      [ "1 day", 1.days ],
      [ "2 days", 2.days ],
      [ "3 days", 3.days ],
      [ "7 days", 7.days ],
      [ "30 days", 30.days ],
      [ "Never", nil ]
    ]
  end
end
