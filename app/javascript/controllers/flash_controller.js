import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.timeout = setTimeout(() => this.remove(), 4000)
  }

  remove() {
    clearTimeout(this.timeout)
    this.element.remove()
  }
}
