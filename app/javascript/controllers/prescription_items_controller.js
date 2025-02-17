// app/javascript/controllers/prescription_items_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["prescriptionItems", "dosageSelect"]

  connect() {
    if (this.prescriptionItemsTarget.children.length === 0) {
      this.addItem()
    }
  }

  addItem(event) {
    if (event) event.preventDefault()
    
    const timestamp = new Date().getTime()
    const template = document.getElementById("prescription-item-template")
    const clone = template.content.cloneNode(true)
    
    clone.querySelectorAll("[id]").forEach(el => {
      el.id = el.id.replace("NEW_RECORD", timestamp)
    })
    
    clone.querySelectorAll("[name]").forEach(el => {
      el.name = el.name.replace("NEW_RECORD", timestamp)
    })
    
    this.prescriptionItemsTarget.appendChild(clone)
  }

  removeItem(event) {
    event.preventDefault()
    const item = event.target.closest(".prescription-item")
    
    if (this.prescriptionItemsTarget.children.length > 1) {
      const hiddenField = item.querySelector("input[name*='_destroy']")
      if (hiddenField) {
        hiddenField.value = "1"
        item.style.display = "none"
      } else {
        item.remove()
      }
    }
  }

  async loadDosages(event) {
    const medicationSelect = event.target
    const prescriptionItem = medicationSelect.closest('.prescription-item')
    const dosageSelect = prescriptionItem.querySelector('select[name*="[dosage_id]"]')
    const medicationId = medicationSelect.value
    
    if (!medicationId) {
      dosageSelect.innerHTML = '<option value="">Select dosage</option>'
      return
    }

    try {
      const response = await fetch(`/medications/${medicationId}/dosages`)
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      
      const dosages = await response.json()
      
      dosageSelect.innerHTML = '<option value="">Select dosage</option>'
      dosages.forEach(dosage => {
        const option = new Option(dosage.display_text, dosage.id)
        dosageSelect.add(option)
      })
    } catch (error) {
      console.error('Error loading dosages:', error)
    }
  }
}
