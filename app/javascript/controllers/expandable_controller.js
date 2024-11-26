import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  closeOnFocusOutside(event) {
    if (!this.element.contains(event.relatedTarget)) {
      this.element.removeAttribute("open")
    }
  }
}
