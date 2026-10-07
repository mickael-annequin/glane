import { Controller } from "@hotwired/stimulus"

// Our own confirmation window for the buttons with data-turbo-confirm ("✓ Stock récupéré", "Retirer"…),
// instead of the browser's one, which shows the address of the site on top and doesn't look like the app.
export default class extends Controller {
  static targets = ["message"]

  connect() {
    Turbo.config.forms.confirm = (message) => this.ask(message)
  }

  // Shows the question, and answers true when "Oui" is touched (false for "Non" or the Escape key).
  ask(message) {
    this.messageTarget.textContent = message
    this.element.returnValue = ""
    this.element.showModal()
    return new Promise((resolve) => {
      this.element.addEventListener("close", () => resolve(this.element.returnValue === "yes"), { once: true })
    })
  }
}
