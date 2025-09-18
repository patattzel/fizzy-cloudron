import { Controller } from "@hotwired/stimulus"
import { toSentence } from "helpers/text_helpers"

export default class extends Controller {
  #hiddenField

  static targets = [ "label", "item", "hiddenFieldTemplate" ]
  static values = {
    selectPropertyName: { type: String, default: "aria-checked" },
    defaultValue: String,
    noSelectionLabel: { type: String, default: "No selection" }
  }

  connect() {
    this.labelTarget.textContent = this.#selectedLabel
  }

  change(event) {
    const item = event.target.closest("[role='checkbox']")
    if (item) {
      this.#toggleSelection(item)
    }
  }

  get #selectedLabel() {
    const selectedValues = this.#selectedValues()
    if (selectedValues.length === 0) {
      return this.noSelectionLabelValue
    }

    const labels = this.#selectedItems().map(item => item.dataset.multiSelectionComboboxLabel)
    return toSentence(labels, {
      two_words_connector: " or ",
      last_word_connector: ", or "
    })
  }

  #toggleSelection(item) {
    const isSelected = item.getAttribute(this.selectPropertyNameValue) === "true"

    if (isSelected) {
      item.setAttribute(this.selectPropertyNameValue, "false")
    } else {
      item.setAttribute(this.selectPropertyNameValue, "true")
    }

    this.#updateHiddenFields()
    this.labelTarget.textContent = this.#selectedLabel
  }

  #updateHiddenFields() {
    this.#clearHiddenFields()
    this.#addHiddenFields()
  }

  #selectedItems() {
    return this.itemTargets.filter(item =>
      item.getAttribute(this.selectPropertyNameValue) === "true"
    )
  }

  #selectedValues() {
    return this.#selectedItems().map(item => item.dataset.multiSelectionComboboxValue)
  }

  #clearHiddenFields() {
    this.element.querySelectorAll('input[type="hidden"]').forEach(field => {
      if (field !== this.hiddenField) {
        field.remove()
      }
    })
  }

  #addHiddenFields() {
    this.#selectedValues().forEach(value => {
      const [field] = this.hiddenFieldTemplateTarget.content.cloneNode(true).children
      field.value = value
      this.element.appendChild(field)
    })
  }
}
