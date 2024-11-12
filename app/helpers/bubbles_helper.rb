module BubblesHelper
  BUBBLE_ROTATION = %w[ 90 80 75 60 45 35 25 5 -45 -40 -75 ]

  def bubble_rotation(bubble)
    value = BUBBLE_ROTATION[Zlib.crc32(bubble.to_param) % BUBBLE_ROTATION.size]

    "--bubble-rotate: #{value}deg;"
  end

  def bubble_size(bubble)
    rank =
      case bubble.activity_count
      when 0..5   then "one"
      when 6..10  then "two"
      when 11..25 then "three"
      when 26..50 then "four"
      else             "five"
      end

    "--bubble-size: var(--bubble-size-#{rank});"
  end

  def bubble_action_button(action_id, icon_name, text)
    button_tag(
      class: "btn full-width justify-start borderless",
      onclick: "document.getElementById('#{action_id}').removeAttribute('hidden')"
    ) do
      safe_join([
        image_tag("#{icon_name}.svg", aria: { hidden: true }, size: 24),
        content_tag(:span, text)
      ])
    end
  end
end
