import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
    options: { type: Object, default: {} }
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers()
    this.#addCustomControls()

    // Remove search box if specified in options
    if (this.optionsValue.disableSearchBox) {
      // Remove any search controls if they exist
      const searchControls = document.querySelectorAll('.mapboxgl-ctrl-geocoder');
      searchControls.forEach(control => control.remove());

      // Prevent search controls from being added
      this.map.addControl = function(control) {
        if (control.constructor.name !== "MapboxGeocoder") {
          mapboxgl.Map.prototype.addControl.apply(this, arguments);
        }
      };
    }
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      // Create marker element
      const customMarker = document.createElement("div")
      customMarker.className = "creature-marker"

      // Use the creature's image if available, otherwise use a Pokeball
      if (marker.image_url) {
        customMarker.style.backgroundImage = `url('${marker.image_url}')`
      } else {
        // Fallback to Pokeball HTML structure
        customMarker.innerHTML = `
          <div class="pokeball-top"></div>
          <div class="pokeball-bottom"></div>
          <div class="pokeball-center"></div>
        `
      }

      // Create the marker with no default element
      new mapboxgl.Marker({
        element: customMarker,
        anchor: 'bottom',
        offset: [0, 0]
      })
      .setLngLat([marker.lng, marker.lat])
      .setPopup(popup)
      .addTo(this.map)
    });
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()

    // Add all markers to bounds
    this.markersValue.forEach(marker => {
      bounds.extend([marker.lng, marker.lat])
    })

    // Only fit bounds if we have markers
    if (this.markersValue.length > 0) {
      // Save initial center and zoom instead of bounds
      this.initialCenter = this.markersValue[0];
      this.initialZoom = 12; // Default zoom level

      // Set the initial view with a sensible zoom
      this.map.fitBounds(bounds, {
        padding: 70,
        maxZoom: 14, // Prevent zooming in too far
        duration: 0
      });
    }
  }

  #addCustomControls() {
    // Create a container for our custom controls
    const customControlsContainer = document.createElement('div')
    customControlsContainer.className = 'pokemon-map-controls'

    // Create Reset View button
    const resetButton = document.createElement('button')
    resetButton.className = 'pokemon-map-button reset'
    resetButton.innerHTML = 'Reset'
    resetButton.title = 'Return to starting view'
    resetButton.addEventListener('click', () => {
      // Instead of using bounds, fly to the initial marker at a fixed zoom
      if (this.initialCenter) {
        this.map.flyTo({
          center: [this.initialCenter.lng, this.initialCenter.lat],
          zoom: this.initialZoom,
          duration: 1000
        });
      }
    })

    // Create Zoom In button
    const zoomInButton = document.createElement('button')
    zoomInButton.className = 'pokemon-map-button zoom-in'
    zoomInButton.innerHTML = '+'
    zoomInButton.title = 'Zoom in'
    zoomInButton.addEventListener('click', () => {
      this.map.zoomIn()
    })

    // Create Zoom Out button
    const zoomOutButton = document.createElement('button')
    zoomOutButton.className = 'pokemon-map-button zoom-out'
    zoomOutButton.innerHTML = '-'
    zoomOutButton.title = 'Zoom out'
    zoomOutButton.addEventListener('click', () => {
      this.map.zoomOut()
    })

    // Add buttons to container
    customControlsContainer.appendChild(resetButton)
    customControlsContainer.appendChild(zoomInButton)
    customControlsContainer.appendChild(zoomOutButton)

    // Add the custom controls container to the map
    this.element.appendChild(customControlsContainer)
  }
}
