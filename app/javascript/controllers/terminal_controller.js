import { Controller } from "@hotwired/stimulus"
import { HttpStatus } from "helpers/http_helpers"
import { delay, nextFrame } from "helpers/timing_helpers"
import { marked } from "marked"

export default class extends Controller {
  static targets = [ "input", "form", "confirmation", "redirected" ]
  static classes = [ "error", "confirmation", "help" ]
  static values = { originalInput: String, waitingForConfirmation: Boolean, autoSubmitAfterRedirection: Boolean }

  connect() {
    if (this.waitingForConfirmationValue) { this.focus() }
    if (this.autoSubmitAfterRedirectionValue) { this.submitAfterRedirection() }
  }

  // Actions

  focus() {
    this.inputTarget.setSelectionRange(this.inputTarget.value.length, this.inputTarget.value.length)
    this.inputTarget.focus()
  }

  executeCommand(event) {
    if (this.#showHelpCommandEntered) {
      this.#showHelpMenu()
      event.preventDefault()
      event.stopPropagation()
    } else {
      this.hideHelpMenu()
    }
  }

  hideHelpMenu() {
    if (this.#showHelpCommandEntered) { this.#reset() }
    this.element.classList.remove(this.helpClass)
  }

  handleKeyPress(event) {
    if (this.waitingForConfirmationValue) {
      this.#handleConfirmationKey(event.key.toLowerCase())
      event.preventDefault()
    }
  }

  handleCommandResponse(event) {
    const response = event.detail.fetchResponse?.response

    if (event.detail.success) {
      if (response.headers.get("Content-Type")?.includes("application/json")) {
        response.json().then((responseJson) => {
          this.element.querySelector("#chat-insight").innerHTML = marked.parse(responseJson.message)
        })
      }
      this.#reset()
    } else if (response) {
      this.#handleErrorResponse(response)
    }
  }

  restoreCommand(event) {
    const target = event.target.querySelector("[data-line]") || event.target
    if (target.dataset.line) {
      this.#reset(target.dataset.line)
      this.focus()
    }
  }

  hideError() {
    this.element.classList.remove(this.errorClass)
  }

  get #showHelpCommandEntered() {
    return [ "/help", "/?" ].includes(this.inputTarget.value)
  }

  #showHelpMenu() {
    this.element.classList.add(this.helpClass)
  }

  get #isHelpMenuOpened() {
    return this.element.classList.contains(this.helpClass)
  }

  async #handleErrorResponse(response) {
    const status = response.status

    if (status === HttpStatus.UNPROCESSABLE) {
      this.#showError()
    } else if (status === HttpStatus.CONFLICT) {
      await this.#handleConflictResponse(response)
    }
  }

  #reset(inputValue = "") {
    this.inputTarget.value = inputValue
    this.confirmationTarget.value = ""
    this.redirectedTarget.value = ""
    this.waitingForConfirmationValue = false
    this.originalInputValue = null
    this.autoSubmitAfterRedirectionValue = false

    this.element.classList.remove(this.errorClass)
    this.element.classList.remove(this.confirmationClass)
  }

  #showError() {
    this.element.classList.add(this.errorClass)
  }

  async #handleConflictResponse(response) {
    const { commands, redirect_to } = await response.json()

    this.originalInputValue = this.inputTarget.value

    if (commands && commands.length) {
      this.#requestConfirmation(commands)
    } else {
      this.autoSubmitAfterRedirectionValue = true
    }
    if (redirect_to) {
      Turbo.visit(redirect_to, { frame: "cards" })
    }
  }

  async #requestConfirmation(commands) {
    const message = commands[0]

    this.element.classList.add(this.confirmationClass)
    this.inputTarget.value = `${message}? [Y/n] `

    this.waitingForConfirmationValue = true
  }

  #handleConfirmationKey(key) {
    if (key === "enter" || key === "y") {
      this.#submitWithConfirmation()
    } else if (key === "escape" || key === "n") {
      this.#reset(this.originalInputValue)
    }
  }

  #submitWithConfirmation() {
    this.inputTarget.value = this.originalInputValue
    this.confirmationTarget.value = "confirmed"
    this.formTarget.requestSubmit()
  }

  submitAfterRedirection() {
    this.inputTarget.value = this.originalInputValue
    this.redirectedTarget.value = "redirected"
    this.formTarget.requestSubmit()
  }
}
