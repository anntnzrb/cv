#import "/templates/vantage/main.typ": (
  primary_colour, skill, styled-link, term, vantage,
)
#let configuration = yaml("/src/vantage.yaml")

#vantage(
  name: configuration.contacts.name,
  position: configuration.position,
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
    (
      name: "github",
      link: configuration.contacts.github.url,
      display: configuration.contacts.github.displayText,
    ),
    (
      name: "linkedin",
      link: configuration.contacts.linkedin.url,
      display: configuration.contacts.linkedin.displayText,
    ),
    (name: "location", link: "", display: configuration.contacts.address),
  ),
  tagline: (configuration.tagline),
  [

    == Experience

    #for job in configuration.jobs [
      === #job.position \
      #if "product" in job [
        #if "link" in job.product and job.product.link != "" [
          _#link(job.company.link)[#job.company.name]_ - #styled-link(job.product.link)[#job.product.name] \
        ] else [
          _#link(job.company.link)[#job.company.name]_ - #job.product.name \
        ]
      ] else [
        _#link(job.company.link)[#job.company.name]_ \
      ]
      #term[#job.from --- #job.to][#job.location]

      #for point in job.description [
        - #point
      ]
    ]

  ],
  [
    == Objective

    #configuration.objective


    == Education

    #for edu in configuration.education [
      === #if edu.place.link != "" [
        #link(edu.place.link)[#edu.place.name]\
      ] else [
        #edu.place.name\
      ]

      #edu.from - #edu.to #h(1fr) #edu.location

      #if edu.major != "" [
        #edu.degree in #edu.major
      ] else [
        #edu.degree
      ]

    ]

    == Skills/Exposure

    • #configuration.skills.join(" • ")

    == Technologies & Tools

    • #configuration.technologies.join(" • ")

    #if "methodology" in configuration [
      == Methodology/Approach
      #for method in configuration.methodology [
        • #method
      ]
    ]

    == Languages
    #for language in configuration.languages [
      • #language
    ]

    #if "achievements" in configuration [
      == Achievements/Certifications

      #for achievement in configuration.achievements [
        === #achievement.name
        \
        #achievement.description
      ]
    ]

    #if "references" in configuration [
      == References

      #for reference in configuration.references [
        *#reference.name - #emph[#reference.title]* \
        #reference.description \
        #link("mailto:" + reference.email)[#reference.email]#if (
          "phone" in reference
        ) [ | #reference.phone] \
      ]
    ]

  ],
)
