import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {
  // Define the target elements we'll need to access
  static targets = ["startDate", "endDate"]

  // Define any values we want to pass from HTML to JavaScript
  static values = {
    bookedDates: Array
  }

  connect() {
    console.log("Datepicker controller connected")

    // Get flatpickr elements
    this.inputElement = this.element.querySelector('input[type="text"]');

    // Format booked dates for disabling
    let disabledRanges = []

    // Only process booked dates if we have any
    if (this.hasBookedDatesValue && this.bookedDatesValue.length > 0) {
      console.log("Processing booked dates:", this.bookedDatesValue)

      // Transform our dates into the format Flatpickr expects
      disabledRanges = this.bookedDatesValue.map(range => ({
        from: range.start,
        to: range.end
      }))
    }

    // Configure Flatpickr
    const config = {
      mode: "range",                  // Enable date range selection
      dateFormat: "Y-m-d",            // Format dates as YYYY-MM-DD
      disable: disabledRanges,        // Disable already booked dates
      minDate: "today",               // Prevent booking in the past
      maxDate: new Date().fp_incr(60), // Limit bookings to 60 days ahead
      showMonths: 1,                  // Show only one month
      static: true,

      // When the selected dates change
      onChange: (selectedDates, dateStr) => {
        console.log("Date selection changed:", dateStr)

        // Only update if we have a complete range (two dates)
        if (selectedDates.length === 2) {
          const startDate = selectedDates[0];
          const endDate = selectedDates[1];

          // Update the hidden form fields
          this.startDateTarget.value = this.formatDate(startDate)
          this.endDateTarget.value = this.formatDate(endDate)

          // Calculate and display the total price
          this.calculateTotal(startDate, endDate)
        }
      }
    }

    // Initialize Flatpickr
    console.log("Initializing flatpickr")
    this.fp = flatpickr(this.inputElement, config);
  }

  // Format date to YYYY-MM-DD for form submission
  formatDate(date) {
    return date.toISOString().split('T')[0]
  }

  // Calculate the total price based on selected dates
  calculateTotal(startDate, endDate) {
    // Calculate number of days (including start and end date)
    const oneDay = 24 * 60 * 60 * 1000
    const diffDays = Math.round(Math.abs((endDate - startDate) / oneDay)) + 1

    // Get price per day from the data attribute
    const pricePerDayElement = document.querySelector('[data-price-per-day]')
    if (!pricePerDayElement) return

    const pricePerDay = parseFloat(pricePerDayElement.dataset.pricePerDay)

    // Calculate total
    const total = diffDays * pricePerDay

    // Update the total display
    const totalElement = document.querySelector('[data-booking-total]')
    if (totalElement) {
      totalElement.textContent = `$${total.toFixed(2)} (${diffDays} days at $${pricePerDay} per day)`
    }
  }

  // Clean up when controller is disconnected
  disconnect() {
    if (this.fp) {
      console.log("Cleaning up flatpickr")
      this.fp.destroy()
    }
  }
}