import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { key: String }
  static targets = [ "input", "section" ]

  sectionTargetConnected() {
    this.#restoreToggles()
  }

  // When toggling, save the state to localStorage as long as it's not
  // temporarily expanded during a filter
  toggle(event) {
    const section = event.target

    if (!section.hasAttribute("data-temp-expand")) {
      if (section.open) {
        localStorage.removeItem(this.#localStorageKey(section))
      } else {
        localStorage.setItem(this.#localStorageKey(section), true)
      }
    }
  }

  showWhileFiltering() {
    if (this.inputTarget.value) {
      for (const section of this.sectionTargets) {
        section.setAttribute("data-temp-expand", true)
        section.open = true
      }
    } else {
      this.#restoreToggles()
    }
  }

  #restoreToggles() {
    for (const section of this.sectionTargets) {
      const isCollapsed = localStorage.getItem(this.#localStorageKey(section)) != null
      if (isCollapsed) section.open = false
      section.removeAttribute("data-temp-expand")
    }
  }

  #localStorageKey(section) {
    return section.getAttribute("data-nav-section-expander-key-value")
  }
}
