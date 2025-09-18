import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ["filtersSet"]
  static targets = ["field"]

  async connect() {
  }

  async fieldTargetConnected(field) {
    this.#toggleFiltersSetClass(this.#isFieldSet(field))
  }

  #toggleFiltersSetClass(shouldAdd) {
    this.element.classList.toggle(this.filtersSetClass, this.#hasFiltersSet)
  }

  get #hasFiltersSet() {
    return this.fieldTargets.some(field => this.#isFieldSet(field))
  }

  #isFieldSet(field) {
    const value = field.value?.trim()
    if (!value) return false

    const defaultValue = this.#defaultValueForField(field)
    return defaultValue ? value !== defaultValue : true
  }

  #defaultValueForField(field) {
    const comboboxContainer = field.closest("[data-combobox-default-value-value]")
    return comboboxContainer?.dataset?.comboboxDefaultValueValue
  }
}
