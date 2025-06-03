import { Controller } from "@hotwired/stimulus"
import { debounce } from "helpers/timing_helpers"

export default class extends Controller {
  static targets = [ "input", "item" ]

  initialize() {
    this.filter = debounce(this.filter.bind(this), 100)
  }

  filter() {
    this.itemTargets.forEach(item => {
      if (item.innerText.toLowerCase().includes(this.inputTarget.value.toLowerCase())) {
        item.removeAttribute("hidden")
      } else {
        item.toggleAttribute("hidden", true)
      }
    })

    this.dispatch("changed")
  }
}
