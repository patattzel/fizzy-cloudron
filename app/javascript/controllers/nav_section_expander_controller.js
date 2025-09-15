import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { key: String }

  connect() {
    this.#restoreToggle()
  }

  toggle() {
    if (this.element.open) {
      localStorage.removeItem(this.#localStorageKey)
    } else {
      localStorage.setItem(this.#localStorageKey, this.keyValue)
    }
  }

  #restoreToggle() {
    const isCollapsed = localStorage.getItem(this.#localStorageKey) != null
    if (isCollapsed) this.element.open = false
  }

  get #localStorageKey() {
    return this.keyValue
  }
}
