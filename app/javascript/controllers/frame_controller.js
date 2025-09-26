import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  morphRender({ detail }) {
    detail.render = function (currentElement, newElement) {
      Turbo.morphChildren(currentElement, newElement)
    }
  }

  morphReload(event) {
    const newElement = event.detail.newElement
    if (newElement && newElement.tagName === "TURBO-FRAME") {
      event.preventDefault()
      this.element.reload()
    }
  }
}
