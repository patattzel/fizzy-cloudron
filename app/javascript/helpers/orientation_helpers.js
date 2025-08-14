const EDGE_THRESHOLD = 16

export function orient(el) {
  el.classList.toggle("orient-left", spaceOnRight(el) < EDGE_THRESHOLD)
  el.classList.toggle("orient-right", spaceOnLeft(el) < EDGE_THRESHOLD)
  el.classList.toggle("orient-top", spaceOnBottom(el) < EDGE_THRESHOLD)
}

function spaceOnLeft(el) {
  return el.getBoundingClientRect().left
}

function spaceOnRight(el) {
  return window.innerWidth - el.getBoundingClientRect().right
}

function spaceOnBottom(el) {
  return window.innerHeight - el.getBoundingClientRect().bottom
}
