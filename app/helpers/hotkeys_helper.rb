module HotkeysHelper
  # Pass in an array of chorded keys, e.g. ["ctrl", "shift", "J"]
  def hotkey_label(hotkey)
    hotkey.map do |key|
      if key == "ctrl" && platform.mac?
        "⌘"
      elsif key == "enter"
        platform.mac? ? "return" : "enter"
      else
        key
      end
    end.join()
  end
end
