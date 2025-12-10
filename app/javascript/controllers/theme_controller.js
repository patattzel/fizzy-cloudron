import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["lightButton", "darkButton", "autoButton"]

  connect() {
    this.#applyStoredTheme()
    this.#updateButtons()
  }

  setLight() {
    this.#setTheme("light")
    document.documentElement.setAttribute("data-theme", "light")
    this.#updateButtons()
  }

  setDark() {
    this.#setTheme("dark")
    document.documentElement.setAttribute("data-theme", "dark")
    this.#updateButtons()
  }

  setAuto() {
    this.#setTheme("auto")
    document.documentElement.removeAttribute("data-theme")
    this.#updateButtons()
  }

  get #storedTheme() {
    return localStorage.getItem("theme") || "auto"
  }

  #setTheme(theme) {
    localStorage.setItem("theme", theme)
  }

  #applyStoredTheme() {
    const storedTheme = this.#storedTheme

    if (storedTheme === "light") {
      document.documentElement.setAttribute("data-theme", "light")
    } else if (storedTheme === "dark") {
      document.documentElement.setAttribute("data-theme", "dark")
    } else {
      // auto - don't set data-theme, let CSS media query handle it
      document.documentElement.removeAttribute("data-theme")
    }
  }

  #updateButtons() {
    const storedTheme = this.#storedTheme

    // Reset all buttons
    if (this.hasLightBtnTarget) this.lightButtonTarget.removeAttribute("aria-selected")
    if (this.hasDarkBtnTarget) this.darkButtonTarget.removeAttribute("aria-selected")
    if (this.hasAutoBtnTarget) this.autoButtonTarget.removeAttribute("aria-selected")

    // Highlight active button
    if (storedTheme === "light" && this.hasLightBtnTarget) {
      this.lightButtonTarget.setAttribute("aria-selected", "true")
    } else if (storedTheme === "dark" && this.hasDarkBtnTarget) {
      this.darkButtonTarget.setAttribute("aria-selected", "true")
    } else if (this.hasAutoBtnTarget) {
      this.autoButtonTarget.setAttribute("aria-selected", "true")
    }
  }
}
