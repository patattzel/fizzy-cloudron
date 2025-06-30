import { Controller } from "@hotwired/stimulus"
import { debounce } from "helpers/timing_helpers"

export default class extends Controller {
  static targets = [ "input", "item" ]

  initialize() {
    this.filter = debounce(this.filter.bind(this), 100)
  }

  filter() {
    this.itemTargets.forEach(item => {
      if (this.#convertDiacritics(item.innerText).toLowerCase().includes(this.inputTarget.value.toLowerCase())) {
        item.removeAttribute("hidden")
      } else {
        item.toggleAttribute("hidden", true)
      }
    })

    this.dispatch("changed")
  }

  #convertDiacritics(text) {
    return text.normalize("NFD").replace(/[\u0300-\u036f]/g, "")
  }
}
