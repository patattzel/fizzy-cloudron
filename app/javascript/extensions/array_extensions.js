Array.prototype.toSentence = function() {
  const length = this.length

  switch (length) {
    case 0:
      return ""
    case 1:
      return `${this[0]}.`
    case 2:
      return `${this[0]} and ${this[1]}.`
    default:
      return this.map((item, index) => {
        const isLast = index === length - 1
        return isLast ? `and ${item}.` : item
      }).join(", ")
  }
}
