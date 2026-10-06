import { Controller } from "@hotwired/stimulus"

// Shows a small preview of the photos chosen in the file field, before they are sent.
export default class extends Controller {
  static targets = ["input", "list"]

  show() {
    this.listTarget.replaceChildren(...[...this.inputTarget.files].map((file) => {
      const image = document.createElement("img")
      image.src = URL.createObjectURL(file)
      image.alt = ""
      image.className = "photo-thumb-new"
      return image
    }))
  }
}
