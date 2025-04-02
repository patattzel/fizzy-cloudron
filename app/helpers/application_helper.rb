module ApplicationHelper
  def page_title_tag
    tag.title @page_title || "Fizzy"
  end

  def icon_tag(name, **options)
    classes = class_names "icon icon--#{name}", options.delete(:class)
    options["aria-hidden"] = true

    content_tag :span, "", class: classes, **options
  end
end
