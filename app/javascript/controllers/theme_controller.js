import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["lightButton", "darkButton", "autoButton"]

  connect() {
    this.#applyStoredTheme()
  }

  setLight() {
    this.#setTheme("light")
  }

  setDark() {
    this.#setTheme("dark")
  }

  setAuto() {
    this.#setTheme("auto")
  }

  get #storedTheme() {
    return localStorage.getItem("theme") || "auto"
  }

  #setTheme(theme) {
    localStorage.setItem("theme", theme)

    theme === "auto" ? document.documentElement.removeAttribute("data-theme") : document.documentElement.setAttribute("data-theme", theme)

    this.#updateButtons()
  }

  #applyStoredTheme() {
    this.#setTheme(this.#storedTheme)
  }

  #updateButtons() {
    const storedTheme = this.#storedTheme

    if (this.lightButtonTarget) { this.lightButtonTarget.checked = (storedTheme === "light") }
    if (this.darkButtonTarget)  { this.darkButtonTarget.checked  = (storedTheme === "dark") }
    if (this.autoButtonTarget)  { this.autoButtonTarget.checked  = (storedTheme !== "light" && storedTheme !== "dark") }
  }
}
