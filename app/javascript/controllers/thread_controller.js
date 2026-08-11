import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggleReply(event) {
    const button = event.currentTarget
    const form = document.getElementById(button.dataset.replyForm)
    if (!form) return

    const opening = form.hidden
    form.hidden = !opening
    button.setAttribute("aria-expanded", opening.toString())
    button.textContent = opening ? "Cancel" : "Reply"
    if (opening) form.querySelector("textarea")?.focus()
  }
}
