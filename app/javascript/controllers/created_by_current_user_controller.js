import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "creation" ]
  static classes = [ "mine" ]

  creationTargetConnected(element) {
    if (element.dataset.creatorId == Current.user.id) {
      element.classList.add(this.mineClass)
    }
  }
}
