import { Controller } from "@hotwired/stimulus"
import { debounce } from "helpers/timing_helpers"

export default class extends Controller {
  static targets = ["input"]
  static values = { key: String }

  initialize() {
    this.save = debounce(this.save.bind(this), 300)
  }

  connect() {
    this.#restoreContent()
  }

  submit({ detail: { success } }) {
    if (success) {
      this.#clear()
    }
  }

  save() {
    const content = this.inputTarget.value
    if (content) {
      localStorage.setItem(this.keyValue, content)
    } else {
      this.#clear()
    }
  }

  // Private

  #clear() {
    localStorage.removeItem(this.keyValue)
  }

  #restoreContent() {
    const savedContent = localStorage.getItem(this.keyValue)
    if (savedContent) {
      this.inputTarget.value = savedContent
      this.#triggerChangeEvent(savedContent)
    }
  }

  #triggerChangeEvent(newValue) {
    if (this.inputTarget.tagName === "HOUSE-MD") {
      this.inputTarget.dispatchEvent(new CustomEvent('house-md:change', {
        bubbles: true,
        detail: {
          previousContent: '',
          newContent: newValue
        }
      }))
    }
  }
}
