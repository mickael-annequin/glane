import { Controller } from "@hotwired/stimulus"

// Reservation form: when another day is chosen, the "Heure" menu only offers that day's opening times.
export default class extends Controller {
  static targets = ["hour"]
  static values = { times: Object } // { "2026-10-07": ["09:00", "09:15", …], … }

  showTimes(event) {
    const previous = this.hourTarget.value
    const times = this.timesValue[event.target.value] || []
    const blank = new Option("Choisir une heure", "")
    const options = times.map((clock) => new Option(clock.replace(/^0/, "").replace(":", "h"), clock))
    this.hourTarget.replaceChildren(blank, ...options)
    if (times.includes(previous)) this.hourTarget.value = previous
  }
}
