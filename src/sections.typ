#import "/templates/vantage/main.typ": styled-link, term

#let build-experience(jobs) = [
  #if jobs.len() > 0 [
    == Experience

    #for job in jobs [
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
  ]
]

#let build-sidebar(configuration) = [
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

  #if "skills" in configuration and configuration.skills.len() > 0 [
    == Skills/Exposure
    • #configuration.skills.join(" • ")
  ]

  #if "technologies" in configuration and configuration.technologies.len() > 0 [
    == Technologies & Tools
    • #configuration.technologies.join(" • ")
  ]

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

]