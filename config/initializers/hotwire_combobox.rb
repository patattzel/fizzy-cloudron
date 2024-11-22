class ActionView::Helpers::FormBuilder
  def combobox(...)
    super do |combobox|
      combobox.customize_main_wrapper class: "btn"
      combobox.customize_input data: { autofocus_target: "element" }
      yield combobox if block_given?
    end
  end
end
