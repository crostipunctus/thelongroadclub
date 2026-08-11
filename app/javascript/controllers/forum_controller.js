import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["topic", "query", "nav", "toast"]

  filter() {
    const query = this.queryTarget.value.toLowerCase().trim()
    this.topicTargets.forEach((topic) => {
      topic.hidden = !topic.textContent.toLowerCase().includes(query)
    })
  }

  toggleNav() {
    this.navTarget.classList.toggle("is-open")
  }

  async bookmark(event) {
    const button = event.currentTarget
    const url = button.dataset.bookmarkUrl
    if (!url) {
      window.location.href = "/login"
      return
    }

    const saved = button.classList.contains("is-saved")
    button.disabled = true
    try {
      const response = await fetch(url, {
        method: saved ? "DELETE" : "POST",
        headers: {
          "Accept": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")?.content
        }
      })
      if (!response.ok) throw new Error("Bookmark request failed")
      button.classList.toggle("is-saved", !saved)
      button.setAttribute("aria-label", saved ? "Save discussion" : "Remove bookmark")
    } finally {
      button.disabled = false
    }
  }
}
