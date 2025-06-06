import { Controller } from "@hotwired/stimulus"
import { signedDifferenceInDays } from "helpers/date_helpers"

const REFRESH_INTERVAL = 3_600_000 // 1 hour (in milliseconds)

export default class extends Controller {
  static targets = [ "entropy", "top", "center", "bottom", "stalled" ]
  static values = { entropy: Object, stalled: Object }

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
    } else if (this.#isStalled) {
      this.#showStalled()
    } else {
      this.#hide()
    }
  }

  get #hasEntropy() {
    return this.#entropyCleanupInDays < this.entropyValue.daysBeforeReminder
  }

  get #entropyCleanupInDays() {
    this.entropyCleanupInDays ??= signedDifferenceInDays(new Date(), new Date(this.entropyValue.closesAt))
    return this.entropyCleanupInDays
  }

  #showEntropy() {
    this.#render({
      target: "entropy",
      top: this.#entropyCleanupInDays < 1 ? this.entropyValue.action : `${this.entropyValue.action} in`,
      center: this.#entropyCleanupInDays < 1 ? "!" : this.#entropyCleanupInDays,
      bottom: this.#entropyCleanupInDays < 1 ? "Today" : (this.#entropyCleanupInDays === 1 ? "day" : "days"),
    })
  }

  #render({ target, top, center, bottom }) {
    this.topTarget.innerHTML = top
    this.centerTarget.innerHTML = center
    this.bottomTarget.innerHTML = bottom

    const entropyTarget = target === "entropy"
    this.entropyTarget.toggleAttribute("hidden", !entropyTarget)
    this.stalledTarget.toggleAttribute("hidden", entropyTarget)

    this.#show()
  }

  get #isStalled() {
    return this.stalledValue.lastActivitySpikeAt && signedDifferenceInDays(new Date(this.stalledValue.lastActivitySpikeAt), new Date()) > this.stalledValue.stalledAfterDays
  }

  #showStalled() {
    this.#render({
      target: "stalled",
      top: "Stalled for",
      center: signedDifferenceInDays(new Date(this.stalledValue.lastActivitySpikeAt), new Date()),
      bottom: "days"
    })
  }

  #hide() {
    this.element.toggleAttribute("hidden", true)
  }

  #show() {
    this.element.removeAttribute("hidden")
  }
}
