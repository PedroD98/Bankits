import { Controller } from "@hotwired/stimulus"
// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
    this.modal = new bootstrap.Modal(this.element)

    this.modal.show()
  }

  close(event) {
    event.preventDefault()
    
    this.element.addEventListener('hidden.bs.modal', () => {
      this.element.remove()
    })

    this.modal.hide()
  }
}
