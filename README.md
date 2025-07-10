# annt's CV

## Architecture

- `src/profile.yaml` - Single source of truth for facts (dates, companies, etc.)
- `src/locales/{lang}.yaml` - Language-specific content (titles, descriptions)
- `src/languages.yaml` - Central language configuration

## Quick Start

```bash
./bin/cv help # see all options
```

## Editing

- `src/profile.yaml` - Add/update jobs, education, skills, etc.
- `src/locales/en.yaml` - English descriptions and titles
- `src/locales/es.yaml` - Spanish ...
- `src/languages.yaml` - Language configuration

## Adding Languages

1. Add language to `src/languages.yaml`
2. Add UI strings to `src/i18n.yaml`
3. Create `src/locales/{lang}.yaml`
4. Run `./bin/cv validate` to verify
