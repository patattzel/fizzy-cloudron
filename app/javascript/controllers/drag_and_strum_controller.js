import { Controller } from "@hotwired/stimulus"

const INSTRUMENTS = [
  [
    "/audio/banjo/A.mp3",
    "/audio/banjo/B.mp3",
    "/audio/banjo/C.mp3",
    "/audio/banjo/D.mp3",
    "/audio/banjo/E.mp3"
  ],
  [
    "/audio/harpsichord/A.mp3",
    "/audio/harpsichord/B.mp3",
    "/audio/harpsichord/C.mp3",
    "/audio/harpsichord/D.mp3",
    "/audio/harpsichord/E.mp3"
  ],
  [
    "/audio/piano/A.mp3",
    "/audio/piano/B.mp3",
    "/audio/piano/C.mp3",
    "/audio/piano/D.mp3",
    "/audio/piano/E.mp3"
  ],
  [
    "/audio/vibes/A.mp3",
    "/audio/vibes/B.mp3",
    "/audio/vibes/C.mp3",
    "/audio/vibes/D.mp3",
    "/audio/vibes/E.mp3"
  ],
]

export default class extends Controller {
  static targets = [ "container" ]

  connect() {
    this.instrumentIndex = 0
    this.preloadedAudioFiles = []

    document.addEventListener("keydown", this.handleKeyDown.bind(this));
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeyDown.bind(this));
  }

  handleKeyDown(event) {
    if (event.shiftKey) {
      this.instrumentIndex = this.#getInstrumentIndex(event)

      if (this.instrumentIndex < INSTRUMENTS.length) {
        this.#preloadAudioFiles(this.instrumentIndex)
      }
    }
  }

  dragEnter(event) {
    event.preventDefault()
    const container = this.#containerContaining(event.target)

    if (!container) { return }

    if (container !== this.sourceContainer && event.shiftKey) {
      this.#playSound()
    }
  }

  #getInstrumentIndex(event) {
    const number = Number(event.code.replace("Digit", ""))
    return isNaN(number) ? 0 : number
  }

  #preloadAudioFiles(instrumentIndex) {
    this.preloadedAudioFiles = []
    const audioFiles = INSTRUMENTS[instrumentIndex];

    if (audioFiles) {
      this.preloadedAudioFiles = audioFiles.map(file => {
        const audio = new Audio(file)
        audio.load()
        return audio
      })
    }
  }

  #containerContaining(element) {
    return this.containerTargets.find(container => container.contains(element) || container === element)
  }

  #playSound() {
    const randomIndex = Math.floor(Math.random() * this.preloadedAudioFiles.length)
    const audio = this.preloadedAudioFiles[randomIndex]
    const audioInstance = new Audio(audio.src)

    audioInstance.play()
  }
}
