#import "/templates/vantage/main.typ": vantage
#import "sections.typ": build-certifications, build-experience, build-sidebar

// Language parameter - defaults to "en" if not specified
#let lang = sys.inputs.at("lang", default: "en")

// Error handling and validation functions
#let validate-language(lang, available-langs) = {
  if lang not in available-langs {
    panic(
      "❌ Language '"
        + lang
        + "' not supported. Available: "
        + available-langs.join(", ")
        + ". Please use a supported language or add it to i18n.yaml.",
    )
  }
}

#let get-translation(dict, key, lang: "en", fallback: none) = {
  // Get translation with fallback to English, then to provided fallback
  if lang in dict and key in dict.at(lang) {
    dict.at(lang).at(key)
  } else if "en" in dict and key in dict.at("en") {
    dict.at("en").at(key)
  } else if fallback != none {
    fallback
  } else {
    "[Missing: " + key + "]"
  }
}

// Load internationalization strings
#let i18n = yaml("/src/i18n.yaml")

// Validate language is supported
#validate-language(lang, i18n.keys())

// Load base profile facts and language-specific content
#let base-profile = yaml("/src/profile.yaml")
#let locale-path = "/src/locales/" + lang + ".yaml"
#let locale-content = yaml(locale-path)

// Composition functions for merging facts with translations
#let compose-jobs(base-jobs, locale-jobs) = {
  base-jobs.map(job => {
    let locale-job = locale-jobs.at(job.id, default: ())
    job + locale-job
  })
}

#let compose-education(base-edu, locale-edu) = {
  base-edu.map(edu => {
    let locale-edu-item = locale-edu.at(edu.id, default: ())
    edu + locale-edu-item
  })
}

#let compose-languages(base-langs, locale-langs) = {
  base-langs.map(lang => {
    let locale-lang = locale-langs.at(lang.id, default: lang.id)
    locale-lang
  })
}

#let compose-references(base-refs, locale-refs) = {
  base-refs.map(ref => {
    let locale-ref = locale-refs.at(ref.id, default: ())
    ref + locale-ref
  })
}

// Compose the complete configuration
#let config = (
  contacts: base-profile.contacts + locale-content.contacts,
  position: locale-content.position,
  tagline: locale-content.tagline,
  jobs: compose-jobs(base-profile.jobs, locale-content.jobs),
  objective: locale-content.objective,
  education: compose-education(
    base-profile.education,
    locale-content.education,
  ),
  skills: base-profile.skills,
  technologies: base-profile.technologies,
  languages: compose-languages(
    base-profile.languages,
    locale-content.languages,
  ),
  certifications: base-profile.certifications,
  references: base-profile.references,
)

#let build-contact-link(name, contact-data, prefix: "", display-key: none) = {
  if type(contact-data) == str {
    (name: name, link: prefix + contact-data, display: contact-data)
  } else if type(contact-data) == dictionary {
    (
      name: name,
      link: prefix + contact-data.url,
      display: contact-data.at(display-key, default: contact-data.url),
    )
  }
}

#let contact-links = (
  build-contact-link("email", config.contacts.email, prefix: "mailto:"),
  ..config
    .contacts
    .keys()
    .filter(key => key in ("website", "github", "linkedin"))
    .map(key => build-contact-link(
      key,
      config.contacts.at(key),
      display-key: "displayText",
    )),
  ..if "address" in config.contacts {
    (build-contact-link("location", config.contacts.address),)
  } else { () },
).filter(link => link != none)

// Set document language for proper typography
#set text(lang: lang)

#vantage(
  name: config.contacts.name,
  position: config.at("position", default: none),
  links: contact-links,
  tagline: config.tagline,
  [
    #build-experience(config.at("jobs", default: ()), i18n.at(lang))
    #build-certifications(config.at("certifications", default: ()), i18n.at(
      lang,
    ))
  ],
  build-sidebar(config, i18n.at(lang), locale-content),
)
