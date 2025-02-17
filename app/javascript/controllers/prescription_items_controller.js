import { Controller } from "@hotwired/stimulus"

export default class PrescriptionItemsController extends Controller {
  static targets = ["prescriptionItems", "dosageSelect", "totalCost"]
  
  connect() {
    this.initializeForm()
  }

  // Form Initialization
  initializeForm() {
    if (this.isEmpty()) {
      this.addItem()
    }
    this.recalculatePrice()
  }

  isEmpty() {
    return this.prescriptionItemsTarget.children.length === 0
  }

  // Item Management
  addItem(event) {
    event?.preventDefault()
    const clone = this.createItemFromTemplate()
    this.prescriptionItemsTarget.appendChild(clone)
    this.recalculatePrice()
  }

  removeItem(event) {
    event.preventDefault()
    const item = event.target.closest(".prescription-item")
    
    if (this.canRemoveItem()) {
      this.handleItemRemoval(item)
      this.recalculatePrice()
      this.loadDosages()
    }
  }

  canRemoveItem() {
    return this.prescriptionItemsTarget.children.length > 1
  }

  handleItemRemoval(item) {
    const hiddenField = item.querySelector("input[name*='_destroy']")
    if (hiddenField) {
      this.markItemForDestruction(item, hiddenField)
    } else {
      item.remove()
    }
  }

  markItemForDestruction(item, hiddenField) {
    hiddenField.value = "1"
    item.style.display = "none"
  }

  // Template Management
  createItemFromTemplate() {
    const timestamp = new Date().getTime()
    const template = document.getElementById("prescription-item-template")
    const clone = template.content.cloneNode(true)
    
    this.updateTemplateIds(clone, timestamp)
    return clone
  }

  updateTemplateIds(clone, timestamp) {
    const elementsWithId = clone.querySelectorAll("[id], [name]")
    elementsWithId.forEach(el => {
      if (el.id) el.id = el.id.replace("NEW_RECORD", timestamp)
      if (el.name) el.name = el.name.replace("NEW_RECORD", timestamp)
    })
  }

  // Dosage Management
  async loadDosages(event) {
    if (!event) return
    
    const { medicationSelect, dosageSelect } = this.getDosageElements(event)
    const medicationId = medicationSelect.value

    this.recalculatePrice()

    if (!medicationId) {
      this.resetDosageSelect(dosageSelect)
      return
    }

    try {
      const dosages = await this.fetchDosages(medicationId)
      this.updateDosageOptions(dosageSelect, dosages)
    } catch (error) {
      console.error('Error loading dosages:', error)
      this.handleDosageError(dosageSelect)
    }
  }

  getDosageElements(event) {
    const medicationSelect = event.target
    const prescriptionItem = medicationSelect.closest('.prescription-item')
    const dosageSelect = prescriptionItem.querySelector('select[name*="[dosage_id]"]')
    return { medicationSelect, dosageSelect }
  }

  async fetchDosages(medicationId) {
    const response = await fetch(`/medications/${medicationId}/dosages`)
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    return response.json()
  }

  updateDosageOptions(select, dosages) {
    select.innerHTML = ''
    dosages.forEach(dosage => {
      select.add(new Option(dosage.display_text, dosage.id))
    })
  }

  resetDosageSelect(select) {
    select.innerHTML = '<option value="">Select dosage</option>'
  }

  handleDosageError(select) {
    select.innerHTML = '<option value="">Error loading dosages</option>'
  }

  // Price Calculation
  async recalculatePrice() {
    try {
      const items = this.getPrescriptionItems()
      const data = await this.calculatePrice(items)
      this.updateTotalCost(data.total_cost)
    } catch (error) {
      console.error("Error calculating price:", error)
      this.handlePriceError()
    }
  }

  getPrescriptionItems() {
    const items = Array.from(this.prescriptionItemsTarget.children)
      .filter(item => {
        // Skip hidden/destroyed items
        if (item.style.display === 'none') return false
        
        const destroyField = item.querySelector("input[name*='_destroy']")
        return !(destroyField && destroyField.value === "1")
      })
      .map(item => {
        return {
          medication_id: item.querySelector("select[name*='[medication_id]']")?.value,
          dosage_id: item.querySelector("select[name*='[dosage_id]']")?.value,
          duration: item.querySelector("input[name*='[duration]']")?.value
        }
      })
      .filter(item => 
        item.medication_id && 
        item.dosage_id && 
        item.duration
      )

    return items
  }

  async calculatePrice(items) {
    const response = await fetch("/calculations", {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({ prescription_items: items })
    })

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }

    return response.json()
  }

  updateTotalCost(cost) {
    this.totalCostTarget.textContent = `Total Cost: $${cost}`
  }

  handlePriceError() {
    this.totalCostTarget.textContent = 'Error calculating total cost'
  }
}
