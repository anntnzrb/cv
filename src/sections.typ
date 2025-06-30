#import "/templates/vantage/main.typ": styled-link, term

#let optional-section(config, field, title, content-fn) = if (
  field in config and config.at(field, default: ()).len() > 0
) {
  heading(level: 2)[#title]
  content-fn(config.at(field))
}

#let bullet-list(items) = [• #items.join(" • ")]

#let build-job-entry(job) = [
  === #job.position \
  #if "product" in job [
    _#link(job.company.link)[#job.company.name] - #if job.product.at("link", default: "") != "" {
      styled-link(job.product.link)[#job.product.name]
    } else { job.product.name }_ \
  ] else [
    _#link(job.company.link)[#job.company.name]_ \
  ]
  #term[#job.from --- #job.to][#job.location]

  #job.description.map(point => [- #point]).join()
]

#let build-edu-entry(edu) = [
  === #if edu.place.at("link", default: "") != "" {
    link(edu.place.link)[#edu.place.name]
  } else {
    edu.place.name
  } \
  #edu.from - #edu.to #h(1fr) #edu.location
  #if edu.at("major", default: "") != "" {
    [#edu.degree in #edu.major]
  } else {
    edu.degree
  }
]

#let build-experience(jobs) = if jobs.len() > 0 [
  == Experience
  #jobs.map(build-job-entry).join()
]

#let format-cert-date(date-str) = {
  let months = (
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  )
  let (year, month-num) = date-str.split("/")
  months.at(int(month-num) - 1) + ", " + year
}

#let render-cert-entry(cert) = [
  === ★ #cert.name \
  #h(0.5em)_#cert.issuer #if cert.at("date", default: "") != "" [ (#format-cert-date(cert.date))]_ \
  #h(0.5em)#(
    cert
      .skills
      .slice(0, calc.min(cert.skills.len(), 5))
      .map(skill => [• #skill])
      .join(" ")
  ) \
]

#let build-certifications(certifications) = if certifications.len() > 0 {
  let split-point = 5
  let first-group = certifications.slice(0, calc.min(
    split-point,
    certifications.len(),
  ))

  [
    == Certifications & Diplomas
    #first-group.map(render-cert-entry).join()]

  if certifications.len() > split-point [
    #colbreak()
    == Certifications & Diplomas _(continued)_
    #certifications.slice(split-point).map(render-cert-entry).join()
  ]
}

#let build-sidebar(config) = [
  == Objective
  #config.objective

  == Education
  #config.education.map(build-edu-entry).join()

  #optional-section(config, "skills", "Skills/Exposure", bullet-list)
  #optional-section(config, "technologies", "Technologies & Tools", bullet-list)
  #optional-section(
    config,
    "methodology",
    "Methodology/Approach",
    methods => methods.map(method => [• #method]).join(),
  )

  == Languages
  #config.languages.map(lang => [• #lang]).join()

  #optional-section(
    config,
    "achievements",
    "Achievements/Certifications",
    achievements => achievements
      .map(achievement => [
        === #achievement.name \
        #achievement.description
      ])
      .join(),
  )

  #optional-section(config, "references", "References", refs => refs
    .map(reference => [
      *#reference.name* - #emph[#reference.title] \
      #reference.description \
      #link("mailto:" + reference.email)[#reference.email]#if (
        "phone" in reference
      ) [ | #reference.phone] \
    ])
    .join())
]
