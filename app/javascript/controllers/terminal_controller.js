import { Controller } from "@hotwired/stimulus"
import { HttpStatus } from "helpers/http_helpers"
import { isMultiLineString } from "helpers/text_helpers";
import { marked } from "marked"
import { nextFrame } from "helpers/timing_helpers";

export default class extends Controller {
  static targets = [ "input", "form", "modalTurboFrame" ]
  static classes = [ "error", "busy" ]
  static outlets = [ "dialog" ]

  // Actions

  async focus() {
    await nextFrame()

    this.inputTarget.focus()
    this.inputTarget.selection.placeCursorAtTheEnd()
  }

  executeCommand(event) {
    if (!this.inputTarget.value.trim()) {
      event.preventDefault()
    }
  }

  submitCommand({ target }) {
    this.#submitCommand()
  }

  handleCommandResponse(event) {
    const response = event.detail.fetchResponse?.response

    if (event.detail.success) {
      this.#handleSuccessResponse(response)
    } else if (response) {
      this.#handleErrorResponse(response)
    }
  }

  hideError() {
    this.element.classList.remove(this.errorClass)
  }

  commandSubmitted() {
    this.element.classList.add(this.busyClass)
  }

  #reset(inputValue = "") {
    this.inputTarget.value = inputValue

    this.element.classList.remove(this.errorClass)
    this.element.classList.remove(this.busyClass)
  }

  #handleSuccessResponse(response) {
    if (response.headers.get("Content-Type")?.includes("application/json")) {
      response.json().then((responseJson) => {
        this.#handleJsonResponse(responseJson)
      })
    }
    this.#reset()
  }

  async #handleErrorResponse(response) {
    this.element.classList.add(this.errorClass)
  }

  #handleJsonResponse(responseJson) {
    const { redirect_to, turbo_frame, url } = responseJson

    if (redirect_to) {
      Turbo.visit(redirect_to)
    }

    if (turbo_frame && url) {
      this.#showTurboFrameModal(turbo_frame, url)
    }
  }

  #submitCommand() {
    this.formTarget.requestSubmit()
  }

  #showTurboFrameModal(name, url) {
    this.inputTarget.blur()
    this.modalTurboFrameTarget.id = name
    this.modalTurboFrameTarget.src = url
    this.dialogOutlet.open()
  }
}
