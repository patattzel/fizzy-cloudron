import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "element" ]

  connect() {
    this.observer = new IntersectionObserver(([entry]) => {
      if (entry.isIntersecting) this.elementTarget.focus()
    })
    this.observer.observe(this.elementTarget)
  }

  disconnect() {
    this.observer.disconnect()
  }
}
