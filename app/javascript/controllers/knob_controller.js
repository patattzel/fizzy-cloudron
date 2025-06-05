import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "field", "option", "slider" ]

  connect() {
    this.#index = this.#selectedOption.dataset.index
  }

  optionChanged({ target }) {
    this.#index = target.dataset.index
  }

  sliderChanged({ target }) {
    this.#index = target.value
  }

  set #index(index) {
    this.fieldTarget.style.setProperty("--knob-index", `${index}`);
    this.sliderTarget.value = index
  }

  get #selectedOption() {
    return this.optionTargets.find(option => {
      return option.checked
    })
  }

  set #value(index) {
    this.#optionForIndex(index).checked = true
  }

  #optionForIndex(index) {
    return this.optionTargets.find(option => {
      return option.dataset.index === index;
    })
  }
}
