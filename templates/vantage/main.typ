#let primary_colour = rgb("#3730a3")
#let link_colour = rgb("#12348e")
#let default_icon_shift = 1.5pt
#let findme_icon_shift = 2.5pt

// Pre-computed styling constants
#let skill_height = 0.3em
#let skill_width = 1.5em
#let skill_radius_left = (left: 2em, right: 0em)
#let skill_radius_right = (left: 0em, right: 2em)
#let skill_radius_none = (left: 0em, right: 0em)

// Pre-computed skill box templates
#let skill_box_active(radius) = rect(
  height: skill_height,
  width: skill_width,
  stroke: primary_colour,
  fill: primary_colour,
  radius: radius,
)

#let skill_box_inactive(radius) = rect(
  height: skill_height,
  width: skill_width,
  stroke: inactive_colour,
  fill: inactive_colour,
  radius: radius,
)

#let icon(name, shift: default_icon_shift) = {
  box(baseline: shift, height: 10pt, image("/assets/icons/" + name + ".svg"))
  h(3pt)
}

#let findMe(services) = [
  #set text(8pt)
  #let icon = icon.with(shift: findme_icon_shift)

  #(
    services
      .map(service => [
        #icon(service.name)
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

#let max_rating = 5
#let inactive_colour = rgb("#c0c0c0")

#let skill(name, rating) = [
  #name
  #h(1fr)

  #for i in range(1, max_rating + 1) {
    let radiusValue = if i == 1 {
      skill_radius_left
    } else if i == max_rating {
      skill_radius_right
    } else {
      skill_radius_none
    }

    if i <= rating {
      box(skill_box_active(radiusValue))
    } else {
      box(skill_box_inactive(radiusValue))
    }
  }

  [\ ]
]


#let styled-link(dest, content) = [
  #set text(fill: link_colour, style: "italic")
  #link(dest, content)
]

#let vantage(
  name: "",
  position: none,
  links: (),
  tagline: [],
  leftSide,
  rightSide,
) = {
  set document(
    title: name + "'s CV",
    author: name,
  )
  set text(9.8pt, font: "PT Sans")
  set page(margin: (x: 1.2cm, y: 1.2cm))

  show heading.where(level: 1): it => text(16pt, [#{ it.body } #v(1pt)])

  show heading.where(
    level: 2,
  ): it => text(fill: primary_colour, [
    #{ it.body }
    #v(-7pt)
    #line(length: 100%, stroke: 0.5pt + primary_colour)
  ])

  show heading.where(
    level: 3,
  ): it => text(it.body)

  show heading.where(
    level: 4,
  ): it => text(
    fill: primary_colour,
    it.body,
  )

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
