import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = [ "reveal", "perform" ]
  static targets = [ "button", "content" ]
  static values = { reacterId: Number }

  connect() {
    if (this.#currentUserIsreacter) {
      this.#setAccessibleAttributes()
    }
  }

  reveal() {
    if (this.#currentUserIsreacter) {
      this.element.classList.toggle(this.revealClass)
      this.buttonTarget.focus()
    }
  }

  perform() {
    this.element.classList.add(this.performClass)
  }

  #setAccessibleAttributes() {
    this.contentTarget.setAttribute('tabindex', '0')
    this.contentTarget.setAttribute('aria-describedby', 'delete_reaction_accessible_label')
  }

  get #currentUserIsreacter() {
    return Current.user.id === this.reacterIdValue
  }
}
