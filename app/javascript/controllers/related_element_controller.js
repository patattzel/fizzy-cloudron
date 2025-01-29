import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["related"]
  static classes = ["highlight"]
  static values = { group: String }
  
  highlight(event) {
    const groupValue = event.currentTarget.dataset.relatedElementGroupValue
    
    this.relatedTargets
      .filter(element => element.dataset.relatedElementGroupValue === groupValue)
      .forEach(element => element.classList.add(this.highlightClass))
  }

  unhighlight(event) {
    const groupValue = event.currentTarget.dataset.relatedElementGroupValue
    
    this.relatedTargets
      .filter(element => element.dataset.relatedElementGroupValue === groupValue)
      .forEach(element => element.classList.remove(this.highlightClass))
  }
}
