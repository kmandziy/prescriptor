import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dosageSelect"]

  async loadDosages(event) {
    const medicationId = event.target.value
    const dosageSelect = event.target.closest('.grid').querySelector('select[name*="[dosage_id]"]')
    
    if (!medicationId) {
      dosageSelect.innerHTML = '<option value="">Select dosage</option>'
      return
    }

    try {
      const response = await fetch(`/medications/${medicationId}/dosages`)
      const dosages = await response.json()
      
      dosageSelect.innerHTML = '<option value="">Select dosage</option>'
      dosages.forEach(dosage => {
        const option = new Option(dosage.frequency, dosage.id)
        dosageSelect.add(option)
      })
    } catch (error) {
      console.error('Error loading dosages:', error)
    }
  }
}
