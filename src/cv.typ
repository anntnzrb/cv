#import "/templates/vantage/main.typ": vantage
#import "sections.typ": build-experience, build-certifications, build-sidebar

#let config = yaml("/src/profile.yaml")

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

#vantage(
  name: config.contacts.name,
  position: config.at("position", default: none),
  links: contact-links,
  tagline: config.tagline,
  [
    #build-experience(config.at("jobs", default: ()))
    #build-certifications(config.at("certifications", default: ()))
  ],
  build-sidebar(config),
)
