#import "/templates/vantage/main.typ": icon, styled-link, term

#let optional-section(config, field, title, content-fn) = if (
  field in config and config.at(field, default: ()).len() > 0
) {
  heading(level: 2)[#title]
  content-fn(config.at(field))
  [ \ ]
}

#let bullet-list(items) = [• #items.join(" • ")]

#let bullet-list-section(config, field, title) = if (
  field in config and config.at(field, default: ()).len() > 0
) {
  heading(level: 2)[#title]
  config.at(field).map(item => [• #item]).join()
}

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
      ) #edu.degree #locale-content.education.preposition #edu.major]
  } else {
    [#h(0.5em) #icon("graduation-cap") #edu.degree]
  } \
]

#let build-experience(jobs, strings) = if jobs.len() > 0 [
  == #strings.experience
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

#let build-certifications(certifications, strings) = if (
  certifications.len() > 0
) {
  let split-point = 5
  let first-group = certifications.slice(0, calc.min(
    split-point,
    certifications.len(),
  ))

  [
    == #strings.certifications
    #first-group.map(render-cert-entry).join()]

  if certifications.len() > split-point [
    #colbreak()
    == #strings.certifications_continued
    #certifications.slice(split-point).map(render-cert-entry).join()
  ]
}

#let build-sidebar(config, strings, locale-content) = [
  == #strings.objective
  #config.objective

  == #strings.education
  #config.education.map(edu => build-edu-entry(edu, locale-content)).join()

  #bullet-list-section(config, "skills", strings.skills)
  
  #bullet-list-section(config, "technologies", strings.technologies)
  
  #bullet-list-section(config, "methodology", strings.methodology)
  
  #bullet-list-section(config, "languages", strings.languages)

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
  
  #optional-section(config, "references", strings.references, refs => refs
    .map(reference => [
      *#reference.name* - #emph[#reference.title] \
      #reference.description \
      #link("mailto:" + reference.email)[#reference.email]#if (
        "phone" in reference
      ) [ | #reference.phone] \
    ])
    .join())
]
