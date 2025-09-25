module CardsHelper
  def cards_next_page_link(target, page:, filter:, fetch_on_visible: false, data: {}, **options)
    url = cards_previews_path(target: target, page: page.next_param, **filter.as_params)

    if fetch_on_visible
      data[:controller] = "#{data[:controller]} fetch-on-visible"
      data[:fetch_on_visible_url_value] = url
    end

    link_to "Load more",
      url,
      id: "#{target}-load-page-#{page.next_param}",
      data: { turbo_stream: true, **data },
      class: "btn txt-small",
      **options
  end

  def public_collection_cards_next_page_link(collection, target, fetch_on_visible: false, page:, data: {}, **options)
    url = public_collection_card_previews_path(collection.publication.key, target: target, page: page.next_param)

    if fetch_on_visible
      data[:controller] = "#{data[:controller]} fetch-on-visible"
      data[:fetch_on_visible_url_value] = url
    end

    link_to "Load more",
      url,
      id: "#{target}-load-page-#{page.next_param}",
      data: { turbo_stream: true, **data },
      class: "btn txt-small",
      **options
  end

  def card_article_tag(card, id: dom_id(card, :article), **options, &block)
    classes = [
      options.delete(:class),
      ("golden-effect" if card.golden?),
      ("card--considering" if card.considering?),
      ("card--doing" if card.doing?),
      ("card--drafted" if card.drafted?)
    ].compact.join(" ")

    tag.article \
      id: id,
      style: "--card-color: #{card.color}; view-transition-name: #{id}",
      class: classes,
      **options,
      &block
  end

  def button_to_delete_card(card)
    button_to card_path(card),
        method: :delete, class: "btn txt-negative borderless txt-small", data: { turbo_frame: "_top", turbo_confirm: "Are you sure you want to permanently delete this card?" } do
      concat(icon_tag("trash"))
      concat(tag.span("Delete this card"))
    end
  end

  def card_title_tag(card)
    title = [
      card.title,
      "added by #{card.creator.name}",
      "in #{card.collection.name}"
    ]
    title << "assigned to #{card.assignees.map(&:name).to_sentence}" if card.assignees.any?
    title.join(" ")
  end

  def cacheable_preview_parts_for(card, *options)
    [ card, card.workflow, card.collection.entropy_configuration, card.collection.publication, *options ]
  end

  def cards_expander(title, count)
    tag.header class: "cards__expander", data: { action: "click->collapsible-columns#toggle" }, style: "--card-count: #{[ count, 20 ].min}", aria: { role: "button" } do
      concat(tag.span count > 99 ? "99+" : count, class: "cards__expander-count")
      concat(tag.h2 title, class: "cards__expander-title")
      concat(tag.div class: "cards__expander-menu position-relative", data: { controller: "dialog", action: "keydown.esc->dialog#close click@document->dialog#closeOnClickOutside" } do
        concat(tag.button class: "btn btn--circle txt-x-small borderless", data: { action: "click->dialog#open:stop" } do
          concat(icon_tag "menu-dots-horizontal", class: "translucent")
          concat(tag.span "Column options", class: "for-screen-reader")
        end)
        concat(tag.dialog class: "popup panel flex-column gap fill-white shadow txt-small margin-block-double", data: { dialog_target: "dialog" } do
          concat(tag.ul class: "popup__list" do
            concat(tag.li class: "popup__item" do
              concat(tag.button "Rename column", class: "popup__btn btn")
            end)
            concat(tag.li class: "popup__item" do
              concat(tag.button "Delete column", class: "popup__btn btn")
            end)
          end)
        end)
      end)
    end
  end
end
