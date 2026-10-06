import { Controller } from "@hotwired/stimulus"

// Gathers the photos taken with the camera or chosen in the gallery (each new choice adds to the previous ones),
// shows a preview of each with a ✕ to remove it, and puts them all in the hidden field that the form sends.
export default class extends Controller {
  static targets = ["input", "list"]

  connect() {
    this.files = []
  }

  add(event) {
    this.files.push(...event.target.files)
    event.target.value = "" // so that the same photo can be chosen again after removing it
    this.update()
  }

  remove(event) {
    this.files.splice(Number(event.currentTarget.dataset.index), 1)
    this.update()
  }

  update() {
    const transfer = new DataTransfer()
    this.files.forEach((file) => transfer.items.add(file))
    this.inputTarget.files = transfer.files

    this.listTarget.replaceChildren(...this.files.map((file, index) => {
      const item = document.createElement("span")
      item.className = "photo-thumb-new"
      const image = document.createElement("img")
      image.src = URL.createObjectURL(file)
      image.alt = ""
      const button = document.createElement("button")
      button.type = "button"
      button.textContent = "✕"
      button.setAttribute("aria-label", "Enlever cette photo")
      button.dataset.index = index
      button.dataset.action = "photo-preview#remove"
      item.append(image, button)
      return item
    }))
  }
}
