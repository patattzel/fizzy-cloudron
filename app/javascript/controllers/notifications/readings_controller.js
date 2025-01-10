import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  record({ target, params: { url } }) {
    navigator.sendBeacon(url, this.#csrfPayload())
    target.remove()
  }

  #csrfPayload() {
    const data = new FormData()
    data.append("authenticity_token", this.#csrfToken())
    return data
  }

  #csrfToken() {
    return document.querySelector('meta[name="csrf-token"]').content
  }
}
