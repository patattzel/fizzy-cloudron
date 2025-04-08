import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "dialog", "content" ]

  connect() {
    const width = this.dialogTarget.offsetWidth;
  }

  toggle() {
    const isOpen = this.dialogTarget.open;

    if (!isOpen) {
      console.log("isOpen");
    }
  }
}
