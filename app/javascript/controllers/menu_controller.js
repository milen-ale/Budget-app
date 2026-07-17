import { Controller } from "@hotwired/stimulus"

// Toggles the mobile navigation drawer from the navbar hamburger button.
export default class extends Controller {
  static targets = ["drawer", "toggle"]

  toggle() {
    const open = this.drawerTarget.hidden
    this.drawerTarget.hidden = !open
    this.toggleTarget.setAttribute("aria-expanded", String(open))
  }

  close() {
    this.drawerTarget.hidden = true
    this.toggleTarget.setAttribute("aria-expanded", "false")
  }
}
