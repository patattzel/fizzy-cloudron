import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input" ]

  // Actions

  focus() {
    console.debug("CALLED!");
    this.inputTarget.focus()
  }
}
