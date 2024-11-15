import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "chip" ]

  connect() {
    this.chipTargets.forEach(button => this.#showChip(button))
  }

  removeFilter(event) {
    event.preventDefault()
    this.#hideChip(event.target.closest("button"))
  }

  clearCategory({ params: { name } }) {
    name.split(",").forEach(name => {
      this.element.querySelectorAll(`input[name="${name}"]`).forEach(input => {
        input.checked = false
      })
    })
  }

  #showChip(button) {
    button.querySelector("input").disabled = false
    button.hidden = false
  }

  #hideChip(button) {
    button.querySelector("input").disabled = true
    button.hidden = true
  }
}
