import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea", "counter", "submit"]

  connect() {
    this.updateCounter()
  }

  updateCounter() {
    const size = this.textareaTarget.value.length
    this.counterTarget.textContent = `${size} символов`
    this.submitTarget.disabled = size === 0
  }
}
