import { Controller } from "@hotwired/stimulus"

const MAX_ROWS = 25

export default class extends Controller {
  static targets = [ "cell", "item" ]

  cellTargetConnected(target) {
    const dt = new Date(target.dataset.datetime)
    target.classList.toggle("future", dt > new Date())
  }

  itemTargetConnected(target) {
    const dt = new Date(target.dataset.datetime)
    target.style.gridRowStart = MAX_ROWS - dt.getHours()
  }
}
