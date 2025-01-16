import { Controller } from "@hotwired/stimulus"

const MOVE_ITEM_DATA_TYPE = "x-fizzy/move"
const DIVIDER_ITEM_NODE_NAME = "LI"

export default class extends Controller {
  static targets = [ "divider", "dragImage", "count" ]
  static classes = [ "positioned" ]
  static values = { startCount: Number, maxCount: Number }

  connect() {
    this.install()
  }

  install() {
    this.#positionDividerBefore(this.startCountValue)
    this.dividerTarget.classList.add(this.positionedClass)
  }

  configureDrag(event) {
    if (event.target == this.dividerTarget) {
      event.dataTransfer.dropEffect = "move"
      event.dataTransfer.setData(MOVE_ITEM_DATA_TYPE, event.target)
      event.dataTransfer.setDragImage(this.dragImageTarget, 0, 0)
    }
  }

  moveDivider(event) {
    if (event.target.nodeName != DIVIDER_ITEM_NODE_NAME) return

    const targetIndex = this.#items.indexOf(event.target)

    if (targetIndex != this.#dividerIndex && targetIndex <= this.maxCountValue) {
      if (this.#dividerIndex < targetIndex) {
        this.#positionDividerAfter(targetIndex)
      } else {
        this.#positionDividerBefore(targetIndex)
      }
    }
  }

  persist() {
    // TODO
  }

  acceptDrop(event) {
    const isDroppable = event.dataTransfer.types.includes(MOVE_ITEM_DATA_TYPE)
    if (isDroppable) event.preventDefault()
  }

  #positionDividerAfter(index) {
    const position = Math.min(index, this.#items.length - 1, this.maxCountValue)
    this.#items[position].after(this.dividerTarget)
    this.countTarget.textContent = position
  }

  #positionDividerBefore(index) {
    const position = Math.max(index, 1)
    this.#items[position].before(this.dividerTarget)
    this.countTarget.textContent = position
  }

  get #items() {
    return Array.from(this.element.children)
  }

  get #dividerIndex() {
    return this.#items.indexOf(this.dividerTarget)
  }
}
