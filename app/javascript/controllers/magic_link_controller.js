import { Controller } from "@hotwired/stimulus"
import { onNextEventLoopTick } from "helpers/timing_helpers"

export default class extends Controller {
  static targets = [ "input" ]

  submit(event) {
    onNextEventLoopTick(() => {
      this.inputTarget.disabled = true
    })
  }

  paste(event) {
    onNextEventLoopTick(() => {
      this.element.submit()
      this.inputTarget.disabled = true
    })
  }
}
