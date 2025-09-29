import { Controller } from "@hotwired/stimulus"
import { post } from "@rails/request.js"
import { nextFrame } from "helpers/timing_helpers"

export default class extends Controller {
  static targets = [ "item", "container" ]
  static classes = [ "draggedItem", "hoverContainer" ]

  // Actions

  async dragStart(event) {
    event.dataTransfer.effectAllowed = "move"
    event.dataTransfer.dropEffect = "move"
    event.dataTransfer.setData("37ui/move", event.target)

    await nextFrame()
    this.dragItem = this.#itemContaining(event.target)
    this.sourceContainer = this.#containerContaining(this.dragItem)
    this.dragItem.classList.add(this.draggedItemClass)
  }

  dragOver(event) {
    event.preventDefault()
    const container = this.#containerContaining(event.target)
    this.#clearContainerHoverClasses()

    if (!container) { return }

    if (container !== this.sourceContainer) {
      container.classList.add(this.hoverContainerClass)
    }
  }

  async drop(event) {
    const container = this.#containerContaining(event.target)

    if (!container || container === this.sourceContainer) { return }

    this.wasDropped = true
    this.#decreaseCounter(this.sourceContainer)
    const sourceContainer = this.sourceContainer
    await this.#submitDropRequest(this.dragItem, container)
    this.#reloadSourceFrame(sourceContainer);
  }

  dragEnd() {
    this.dragItem.classList.remove(this.draggedItemClass)
    this.#clearContainerHoverClasses()

    if (this.wasDropped) {
      this.dragItem.remove()
    }

    this.sourceContainer = null
    this.dragItem = null
    this.wasDropped = false
  }

  #itemContaining(element) {
    return this.itemTargets.find(item => item.contains(element) || item === element)
  }

  #containerContaining(element) {
    return this.containerTargets.find(container => container.contains(element) || container === element)
  }

  #clearContainerHoverClasses() {
    this.containerTargets.forEach(container => container.classList.remove(this.hoverContainerClass))
  }

  async #submitDropRequest(item, container) {
    const body = new FormData()
    const id = item.dataset.id
    const url = container.dataset.dragAndDropUrl.replaceAll("__id__", id)

    return post(url, { body, headers: { Accept: "text/vnd.turbo-stream.html" } })
  }

  #reloadSourceFrame(sourceContainer) {
    const frame = sourceContainer.querySelector("[data-drag-and-drop-refresh]")
    if (frame) frame.reload()
  }

  #decreaseCounter(sourceContainer) {
    const counterElement = sourceContainer.querySelector("[data-drag-and-drop-counter]")
    if (counterElement) {
      const currentValue = counterElement.textContent.trim()

      if (!/^\d+$/.test(currentValue)) return

      const count = parseInt(currentValue)
      if (count > 0) {
        counterElement.textContent = count - 1
      }
    }
  }
}
