import { Controller } from "@hotwired/stimulus"
import { post } from "@rails/request.js"

export default class extends Controller {
  static targets = [ "turboFrame" ]
  static outlets = [ "dialog" ]
  static values = {
    searchUrl: String,
    searchTurboFrameName: String,
    askUrl: String,
    askTurboFrameName: String
  }

  connect() {
    this.closeModal()
  }

  closeModal() {
    this.dialogOutlet.close()
    this.#clearTurboFrame()
  }

  search(event) {
    if (this.#shouldExecuteHotkey) {
      event.preventDefault()
      this.#openInTurboFrame(this.searchTurboFrameNameValue, this.searchUrlValue)
      this.dialogOutlet.open()
    }
  }

  ask(event) {
    if (this.#shouldExecuteHotkey) {
      event.preventDefault()
      this.#initializeConversation()
      this.#openInTurboFrame(this.askTurboFrameNameValue, this.askUrlValue)
      this.dialogOutlet.open()
    }
  }

  get #shouldExecuteHotkey() {
    const activeElement = document.activeElement

    if (activeElement) {
      const usingInput = activeElement.closest("input, textarea, lexical-editor")
      return !usingInput
    } else {
      return true
    }
  }

  #clearTurboFrame() {
    this.turboFrameTarget.removeAttribute("id")
    this.turboFrameTarget.removeAttribute("src")
    this.turboFrameTarget.innerHtml = ""
  }

  #openInTurboFrame(name, url) {
    this.turboFrameTarget.id = name
    this.turboFrameTarget.src = url
  }

  #initializeConversation() {
    post(this.askUrlValue)
  }
}
