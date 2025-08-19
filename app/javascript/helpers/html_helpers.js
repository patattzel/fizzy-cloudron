export function isInput(element) {
  return !!element.closest("input, textarea, lexical-editor")
}
