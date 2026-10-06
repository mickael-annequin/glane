import { Controller } from "@hotwired/stimulus"

// Suggests real addresses while typing, with the IGN "API Adresse" (free, no key).
// Picking a suggestion fills the address and the hidden position (latitude, longitude) and city.
// Typing again clears the position: the server refuses an address that wasn't picked.
export default class extends Controller {
  static targets = ["input", "latitude", "longitude", "city", "list"]
  static values = { department: String, latitude: Number, longitude: Number }

  search() {
    this.clearPosition()
    clearTimeout(this.timer)
    const text = this.inputTarget.value.trim()
    if (text.length < 3) return this.close()

    // Wait for a short pause in the typing before asking the IGN.
    this.timer = setTimeout(() => this.fetchSuggestions(text), 250)
  }

  async fetchSuggestions(text) {
    this.request?.abort()
    this.request = new AbortController()
    const url = new URL("https://data.geopf.fr/geocodage/search")
    url.search = new URLSearchParams({
      q: text, autocomplete: 1, limit: 10, lat: this.latitudeValue, lon: this.longitudeValue
    })

    try {
      const response = await fetch(url, { signal: this.request.signal })
      const data = await response.json()
      this.show(this.sortByDepartment(data.features).slice(0, 5))
    } catch (error) {
      if (error.name !== "AbortError") this.showMessage("Suggestions indisponibles pour l'instant, réessayez dans un moment.")
    }
  }

  // Addresses of our department first, then the others.
  sortByDepartment(features) {
    const inDepartment = (feature) => (feature.properties.context || "").startsWith(`${this.departmentValue},`)
    return [...features.filter(inDepartment), ...features.filter((feature) => !inDepartment(feature))]
  }

  show(features) {
    if (features.length === 0) return this.showMessage("Aucune adresse trouvée : vérifiez l'orthographe et ajoutez la ville.")

    this.listTarget.replaceChildren(...features.map((feature) => {
      const button = document.createElement("button")
      button.type = "button"
      button.className = "address-suggestion"
      button.setAttribute("role", "option")
      button.textContent = feature.properties.label
      button.addEventListener("click", () => this.pick(feature))
      return button
    }))
    this.listTarget.hidden = false
  }

  showMessage(message) {
    const item = document.createElement("div")
    item.className = "address-suggestion-message"
    item.textContent = message
    this.listTarget.replaceChildren(item)
    this.listTarget.hidden = false
  }

  pick(feature) {
    const [longitude, latitude] = feature.geometry.coordinates
    this.inputTarget.value = feature.properties.label
    this.latitudeTarget.value = latitude
    this.longitudeTarget.value = longitude
    this.cityTarget.value = feature.properties.city || ""
    this.close()
  }

  clearPosition() {
    this.latitudeTarget.value = ""
    this.longitudeTarget.value = ""
    this.cityTarget.value = ""
  }

  close() {
    this.listTarget.hidden = true
  }
}
