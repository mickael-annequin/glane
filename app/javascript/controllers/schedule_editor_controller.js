import { Controller } from "@hotwired/stimulus"

// Planning form: copies the time ranges of the first checked day to the other checked days,
// so that "Monday to Friday, 9h–12h and 14h–17h" is quick to fill in.
export default class extends Controller {
  static targets = ["day"]

  copy() {
    const checked = this.dayTargets.filter((day) => day.querySelector("input[type=checkbox]").checked)
    if (checked.length < 2) return

    const values = [...checked[0].querySelectorAll("select")].map((select) => select.value)
    checked.slice(1).forEach((day) => {
      day.querySelectorAll("select").forEach((select, index) => { select.value = values[index] })
    })
  }
}
