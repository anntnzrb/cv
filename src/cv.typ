#import "/templates/vantage/main.typ": vantage
#import "sections.typ": build-experience, build-sidebar

#let configuration = yaml("/src/profile.yaml")

#vantage(
  name: configuration.contacts.name,
  position: if "position" in configuration { configuration.position } else { none },
  links: (
    (name: "email", link: "mailto:" + configuration.contacts.email),
    ..if "website" in configuration.contacts {
      (
        (
          name: "website",
          link: configuration.contacts.website.url,
          display: configuration.contacts.website.displayText,
        ),
      )
    },
    ..if "github" in configuration.contacts {
      (
        (
          name: "github",
          link: configuration.contacts.github.url,
          display: configuration.contacts.github.displayText,
        ),
      )
    },
    ..if "linkedin" in configuration.contacts {
      (
        (
          name: "linkedin",
          link: configuration.contacts.linkedin.url,
          display: configuration.contacts.linkedin.displayText,
        ),
      )
    },
    ..if "address" in configuration.contacts {
      ((name: "location", link: "", display: configuration.contacts.address),)
    },
  ),
  tagline: configuration.tagline,
  build-experience(if "jobs" in configuration { configuration.jobs } else { () }),
  build-sidebar(configuration),
)
