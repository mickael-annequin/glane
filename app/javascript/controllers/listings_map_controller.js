import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

// Map of the listings: one marker per pickup place (with the number of listings there),
// touching a marker shows them at the bottom of the map. The texts come from the users:
// they are always written with textContent, never as HTML.
export default class extends Controller {
  static targets = ["canvas", "sheet"]
  static values = {
    apiKey: String,
    center: Array, // [longitude, latitude] of the territory
    places: Array, // [{ latitude, longitude, icon, count, listings: [{ id, title, icon, url, details, deadline, urgent, mine }] }]
    home: Array,   // [longitude, latitude] of my structure, if known
    focus: Number  // id of a listing to center the map on
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
      container: this.canvasTarget,
      style: "mapbox://styles/mapbox/streets-v12",
      center: this.centerValue,
      zoom: 8.3,
      language: "fr"
    })
    this.map.addControl(new mapboxgl.NavigationControl({ showCompass: false }))

    if (this.homeValue.length === 2) this.addHomeMarker()
    this.placesValue.forEach((place) => this.addMarker(place))
    this.focusOnListing()
  }

  disconnect() {
    this.map?.remove()
  }

  addHomeMarker() {
    const element = document.createElement("div")
    element.className = "map-home"
    element.title = "Ma structure"
    element.textContent = "🏠"
    new mapboxgl.Marker({ element }).setLngLat(this.homeValue).addTo(this.map)
  }

  addMarker(place) {
    const element = document.createElement("button")
    element.type = "button"
    element.className = "map-marker"
    element.textContent = place.icon
    element.setAttribute("aria-label", place.listings.map((listing) => listing.title).join(", "))
    if (place.count > 1) {
      const count = document.createElement("span")
      count.className = "map-marker-count"
      count.textContent = place.count
      element.append(count)
    }
    element.addEventListener("click", () => this.show(place))
    new mapboxgl.Marker({ element }).setLngLat([place.longitude, place.latitude]).addTo(this.map)
  }

  focusOnListing() {
    if (!this.hasFocusValue) return

    const place = this.placesValue.find((p) => p.listings.some((listing) => listing.id === this.focusValue))
    if (!place) return
    this.map.jumpTo({ center: [place.longitude, place.latitude], zoom: 13 })
    this.show(place)
  }

  // The listings of a place, at the bottom of the map.
  show(place) {
    const close = document.createElement("button")
    close.type = "button"
    close.className = "listings-map-close"
    close.setAttribute("aria-label", "Fermer")
    close.textContent = "✕"
    close.addEventListener("click", () => { this.sheetTarget.hidden = true })

    this.sheetTarget.replaceChildren(close, ...place.listings.map((listing) => this.summary(listing)))
    this.sheetTarget.hidden = false
  }

  summary(listing) {
    const link = document.createElement("a")
    link.href = listing.url
    link.className = "map-summary"

    const icon = document.createElement("span")
    icon.className = "listing-card-picture"
    icon.textContent = listing.icon

    const body = document.createElement("span")
    body.className = "listing-card-body"
    const title = document.createElement("strong")
    title.textContent = listing.title
    const details = document.createElement("span")
    details.className = "text-body-secondary"
    details.textContent = listing.details
    const deadline = document.createElement("span")
    deadline.textContent = listing.deadline
    if (listing.urgent) deadline.className = "text-danger fw-semibold"
    body.append(title, details, deadline)
    if (listing.mine) {
      const badge = document.createElement("span")
      badge.className = "badge listing-card-badge"
      badge.textContent = "Votre structure"
      body.append(badge)
    }

    const arrow = document.createElement("span")
    arrow.className = "map-summary-arrow"
    arrow.textContent = "Voir →"

    link.append(icon, body, arrow)
    return link
  }
}
