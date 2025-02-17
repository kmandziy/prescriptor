import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dosageSelect"]

  connect() {
    console.log("Dosage3 controller connected!")
    console.log("Available dosage targets:", this.dosageSelectTargets)
  }

  async loadDosages(event) {
    console.log('loadDosages called')
    console.log('Event target:', event.target)
    console.log('Selected medication ID:', event.target.value)

    const medicationId = event.target.value
    // Use the Stimulus target instead of querySelector
    const dosageSelect = this.dosageSelectTarget
    
    if (!medicationId) {
      console.log('No medication selected')
      dosageSelect.innerHTML = '<option value="">Select dosage</option>'
      return
    }

    try {
      const url = `/medications/${medicationId}/dosages`
      console.log('Fetching dosages from:', url)
      
      const response = await fetch(url)
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      
      const dosages = await response.json()
      console.log('Received dosages:', dosages)
      
      dosageSelect.innerHTML = '<option value="">Select dosage</option>'
      dosages.forEach(dosage => {
        const option = new Option(dosage.display_text, dosage.id)
        dosageSelect.add(option)
      })
    } catch (error) {
      console.error('Error loading dosages:', error)
      console.error('Error details:', error.message)
    }
  }
}
