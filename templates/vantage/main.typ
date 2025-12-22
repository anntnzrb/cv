#let theme = (
  primary: rgb("#3730a3"),
  link: rgb("#12348e"),
  inactive: rgb("#c0c0c0"),
  icon-shift: (default: 1.5pt, findme: 2.5pt),
  skill: (height: 0.3em, width: 1.5em, max-rating: 5),
  radius: (
    left: (left: 2em, right: 0em),
    right: (left: 0em, right: 2em),
    flat: (left: 0em, right: 0em),
  ),
)

#let skill-box(active: true, radius) = rect(
  height: theme.skill.height,
  width: theme.skill.width,
  stroke: if active { theme.primary } else { theme.inactive },
  fill: if active { theme.primary } else { theme.inactive },
  radius: radius,
)

#let icon(name, shift: theme.icon-shift.default) = {
  box(baseline: shift, height: 10pt, image("/assets/icons/" + name + ".svg"))
  h(3pt)
}

#let findMe(services) = [
  #set text(8pt)
  #(
    services
      .map(service => [
        #icon(service.name, shift: theme.icon-shift.findme)
        #if "display" in service.keys() {
          link(service.link)[#service.display]
        } else {
          link(service.link)
        }
      ])
      .join(h(10pt))
  )
]

#let term(period, location) = [
  #set text(9pt)
  #icon("calendar") #period #h(1fr) #icon("location") #location
]

#let skill(name, rating) = [
  #name #h(1fr)
  #(
    range(1, theme.skill.max-rating + 1)
      .map(i => {
        let radius = (
          theme.radius.left,
          theme.radius.flat,
          theme.radius.right,
        ).at(calc.min(calc.max(i - 1, 0), 2))
        box(skill-box(active: i <= rating, radius))
      })
      .join()
  )
  [\ ]
]


#let styled-link(dest, content) = [
  #set text(fill: theme.link, style: "italic")
  #link(dest, content)
]

#let setup-styles(body) = {
  set text(9.8pt, font: "PT Sans")
  set page(margin: (x: 1.2cm, y: 1.2cm))

  show heading.where(level: 1): it => text(16pt, [#{ it.body } #v(1pt)])

  show heading.where(level: 2): it => text(fill: theme.primary, [
    #{ it.body }
    #v(-7pt)
    #line(length: 100%, stroke: 0.5pt + theme.primary)
  ])

  show heading.where(level: 3): it => text(it.body)

  show heading.where(level: 4): it => text(fill: theme.primary, it.body)

  body
}

#let vantage(
  name: "",
  position: none,
  links: (),
  tagline: [],
  leftSide,
  rightSide,
) = {
  set document(title: name + "'s CV", author: name)

  [= #name]

  if position != none and position != "" {
    text(12pt, weight: "medium", [#position])
    v(0pt)
  }

  if links.len() > 0 {
    findMe(links)
  }

  v(6pt)
  tagline

  grid(
    columns: (7fr, 4fr),
    column-gutter: 2em,
    leftSide, rightSide,
  )
}

#let page-two(leftSide, rightSide) = {
  pagebreak()
  grid(
    columns: (7fr, 4fr),
    column-gutter: 2em,
    leftSide, rightSide,
  )
}
