import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { selector: String }
  static classes = [ "mine" ]

  connect() {
    this.#createdElements.forEach(el => el.classList.add(this.mineClass))
  }

  get #createdElements() {
    return this.element.querySelectorAll(`${this.selectorValue}[data-creator-id='${Current.user.id}']`)
  }
}
