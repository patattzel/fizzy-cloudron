import { Controller } from "@hotwired/stimulus"
import { signedDifferenceInDays } from "helpers/date_helpers"

const REFRESH_INTERVAL = 3_600_000 // 1 hour (in milliseconds)

export default class extends Controller {
  static targets = [ "entropy", "entropyTop", "entropyDays", "entropyBottom", "stalled" ]
  static values = { entropy: Object }

  #timer

  connect() {
    this.#timer = setInterval(this.update.bind(this), REFRESH_INTERVAL)
    this.update()
  }

  disconnect() {
    clearInterval(this.#timer)
  }

  update() {
    if (this.#hasEntropy) {
      this.#showEntropy()
    } else {
      this.#hide()
    }
  }

  get #hasEntropy() {
    return this.#closesInDays < this.entropyValue.daysBeforeReminder
  }

  get #closesInDays() {
    this.closesInDays ??= signedDifferenceInDays(new Date(), new Date(this.entropyValue.closesAt))
    return this.closesInDays
  }

  #showEntropy() {
    this.entropyTopTarget.innerHTML = this.#closesInDays < 1 ? this.entropyValue.action : `${this.entropyValue.action} in`
    this.entropyDaysTarget.innerHTML = this.#closesInDays < 1 ? "!" : this.#closesInDays
    this.entropyBottomTarget.innerHTML = this.#closesInDays < 1 ? "Today" : (this.#closesInDays === 1 ? "day" : "days")

    this.entropyTarget.removeAttribute("hidden")
    this.stalledTarget.toggleAttribute("hidden", true)
    this.#show()
  }

  #hide() {
    this.element.toggleAttribute("hidden", true)
  }

  #show() {
    this.element.removeAttribute("hidden")
  }
}
