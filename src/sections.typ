#import "/templates/vantage/main.typ": icon, styled-link, term

#let optional-section(config, field, title, content-fn) = if (
  field in config and config.at(field, default: ()).len() > 0
) {
  heading(level: 2)[#title]
  content-fn(config.at(field))
  [ \ ]
}

#let bullet-list(items) = [• #items.join(" • ")]

#let bullet-list-section(config, field, title, vertical: false) = if (
  field in config and config.at(field, default: ()).len() > 0
) {
  heading(level: 2)[#title]
  if vertical {
    config.at(field).map(item => [• #item]).join([ \ ])
  } else {
    config
      .at(field)
      .chunks(4)
      .map(row => row.map(item => [• #item]).join([ ]))
      .join([ \ ])
  }
}

#let content-separator() = (
  v(-0.5em)
    + align(center)[#line(length: 3cm, stroke: 0.5pt + gray)]
    + v(-0.5em)
)

#let build-job-entry(job, strings) = [
  #let job-end = if job.to == "present" { strings.present } else { job.to }
  === #job.position \
  #if "product" in job [
    _#link(job.company.link)[#job.company.name] - #if job.product.at("link", default: "") != "" {
      styled-link(job.product.link)[#job.product.name]
    } else { job.product.name }_ \
  ] else [
    _#link(job.company.link)[#job.company.name]_ \
  ]
  #term[#job.from --- #job-end][#job.location#if job.at(
      "hybrid",
      default: false,
    ) [ (#strings.hybrid)]]

  #job.description.map(point => [- #par(justify: true)[#point]]).join()
]

#let build-edu-entry(edu, locale-content) = [
  === #if edu.place.at("link", default: "") != "" {
    link(edu.place.link)[#edu.place.name]
  } else {
    edu.place.name
  } \
  #h(0.5em) #icon("calendar") #edu.from - #edu.to \
  #h(0.5em) #icon("location") #edu.location \
  #if edu.at("major", default: "") != "" {
    [#h(0.5em) #icon(
        "graduation-cap",
      ) #edu.degree #locale-content.education.preposition #linebreak() #h(
        0.5em,
      ) #h(1.6em) #edu.major]
  } else {
    [#h(0.5em) #icon("graduation-cap") #edu.degree]
  } \
]

#let build-experience(jobs, strings) = if jobs.len() > 0 [
  == #strings.experience
  #jobs.map(job => build-job-entry(job, strings)).join(content-separator())
]

#let format-cert-date(date-str, months) = {
  let (year, month-num) = date-str.split("/")
  months.at(int(month-num) - 1) + ", " + year
}

#let render-cert-entry(cert, strings) = [
  #let detail-parts = (
    if cert.at("date", default: "") != "" {
      format-cert-date(cert.date, strings.months)
    },
    if "hours" in cert { str(cert.hours) + "h" },
  ).filter(part => part != none)
  #let detail = if detail-parts.len() > 0 {
    "(" + detail-parts.join(", ") + ")"
  } else {
    ""
  }
  === ★ #cert.name \
  #h(0.5em)_#cert.issuer#if detail != "" { " " + detail }_ \
]

#let build-certifications(certifications, strings) = if (
  certifications.len() > 0
) [
  == #strings.certifications
  #certifications.map(cert => render-cert-entry(cert, strings)).join()
]

#let build-references(refs, strings) = if (refs.len() > 0) {
  let entries = refs.map(ref => [
    *#ref.name* - #emph[#ref.title] \
    #ref.description \
    #icon("email")#link("mailto:" + ref.email)[#raw(ref.email)]#if (
      "phone" in ref
    ) [ | #ref.phone] \
  ])
  [
    == #strings.references
    #entries.join(content-separator())
  ]
}

#let build-sidebar(config, strings, locale-content) = [
  == #strings.education
  #(
    config
      .education
      .map(edu => build-edu-entry(edu, locale-content))
      .join(content-separator())
  )

  #bullet-list-section(config, "skills", strings.skills)

  #bullet-list-section(config, "technologies", strings.technologies)

  #bullet-list-section(config, "methodology", strings.methodology)

  #bullet-list-section(config, "languages", strings.languages, vertical: true)

  #optional-section(
    config,
    "achievements",
    strings.achievements,
    achievements => achievements
      .map(achievement => [
        === #achievement.name \
        #achievement.description
      ])
      .join(),
  )
]
