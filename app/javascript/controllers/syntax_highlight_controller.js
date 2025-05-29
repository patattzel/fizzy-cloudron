import { Controller } from "@hotwired/stimulus"
import { highlightAll } from "actiontext-lexical"

export default class extends Controller {
  connect() {
    highlightAll()
  }
}
