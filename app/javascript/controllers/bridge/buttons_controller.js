import { BridgeComponent } from "@hotwired/hotwire-native-bridge"
import { BridgeElement } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "buttons"
  static targets = [ "button" ]

  connect() {
    window.addEventListener("beforeunload", this.handleBeforeUnload.bind(this))
    window.addEventListener("turbo:before-visit", this.handleBeforeVisit.bind(this))
  }

  disconnect() {
    window.removeEventListener("beforeunload", this.handleBeforeUnload.bind(this))
    window.removeEventListener("turbo:before-visit", this.handleBeforeVisit.bind(this))
  }

  buttonTargetConnected() {
    this.notifyBridgeOfConnect()
  }

  buttonTargetDisconnected() {
    if (!this.#isControllerTearingDown()) {
      this.notifyBridgeOfConnect()
    }
  }

  notifyBridgeOfConnect() {
    const buttons = this.#enabledButtonTargets
      .map((target, index) => {
        const element = new BridgeElement(target)
        return { ...element.getButton(), index }
    })

    this.send("connect", { buttons }, message => {
      this.#clickButton(message)
    })
  }

  notifyBridgeOfDisconnect() {
    this.send("disconnect")
  }

  handleBeforeUnload() {
    this.notifyBridgeOfDisconnect()
  }

  handleBeforeVisit() {
    this.notifyBridgeOfDisconnect()
  }

  #clickButton(message) {
    const selectedIndex = message.data.selectedIndex
    this.#enabledButtonTargets[selectedIndex].click()
  }

  get #enabledButtonTargets() {
    return this.buttonTargets
      .filter(target => !target.closest("[data-bridge-disabled]"))
  }

  #isControllerTearingDown() {
    return !document.body.contains(this.element)
  }
}
