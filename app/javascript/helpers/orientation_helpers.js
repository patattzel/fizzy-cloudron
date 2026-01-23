const EDGE_THRESHOLD = 16

export function orient({ target, anchor = null, reset = false }) {
  target.classList.remove("orient-left", "orient-right")
  target.style.removeProperty("--orient-offset")

  if (reset) return

  const targetGeometry = geometry(target)
  const anchorGeometry = geometry(anchor)

  if (targetGeometry.spaceOnRight < EDGE_THRESHOLD && targetGeometry.spaceOnRight < targetGeometry.spaceOnLeft) {
    const offset = Math.min(0, anchorGeometry.spaceOnLeft + anchorGeometry.width - targetGeometry.width) * -1
    target.classList.add("orient-left")
    target.style.setProperty("--orient-offset", `${offset}px`)
  } else if (targetGeometry.spaceOnLeft < EDGE_THRESHOLD && targetGeometry.spaceOnLeft < targetGeometry.spaceOnRight) {
    const offset = Math.max(0, anchorGeometry.spaceOnLeft + targetGeometry.width - window.innerWidth) * -1
    target.classList.add("orient-right")
    target.style.setProperty("--orient-offset", `${offset}px`)
  }
}

function geometry(el) {
  const rect = el.getBoundingClientRect()
  return {
    spaceOnLeft: rect.left,
    spaceOnRight: window.innerWidth - rect.right,
    width: rect.width
  }
}
