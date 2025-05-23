import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "filename"]

  connect() {
    if (this.hasInputTarget) {
      this.inputTarget.addEventListener('change', this.updateFilename.bind(this))
    }
  }

  updateFilename(event) {
    const input = event.target
    const filenameDisplay = this.filenameTarget

    if (input.files && input.files[0]) {
      filenameDisplay.textContent = input.files[0].name
    } else {
      filenameDisplay.textContent = "No file chosen"
    }
  }
}