import { Controller } from "@hotwired/stimulus"
import { isInput } from "helpers/html_helpers"

export default class extends Controller {
  click(event) {
    if (this.#isClickable && !this.#shouldIgnore(event)) {
      event.preventDefault()
      this.element.click()
    }
  }

  #shouldIgnore(event) {
    return event.defaultPrevented || isInput(event.target)
  }

  get #isClickable() {
    return getComputedStyle(this.element).pointerEvents !== "none"
  }
}
