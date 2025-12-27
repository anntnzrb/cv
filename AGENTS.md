# AGENTS.md

This file provides guidance to AI Agents when working with code in this repository.

## Project Overview

This is a multilingual CV/resume generator built with Typst. It supports generating PDF resumes in multiple languages using a hybrid content management approach with localized templates.

## Development Environment

Use Nix for all operations. No manual setup required.

## Common Commands

```bash
# Build CVs
nix run . -- build [lang]      # Build CV (default: en, available: en es)
nix run . -- build-all         # Build all CVs to out/
nix run . -- watch [lang]      # Watch for changes and auto-rebuild

nix build .#cv-en              # Build English PDF -> result/jago-cv-en.pdf
nix build .#cv-es              # Build Spanish PDF -> result/jago-cv-es.pdf
nix build .#cv-all             # Build all PDFs -> result/

# Formatting
nix fmt                        # Format Typst and shell files

# Validation
nix flake check                # Run format check + build all languages
nix run . -- validate          # Validate data consistency

# Help
nix run . -- help              # Show all available commands
```

## Non-Nix Usage

The `bin/cv` script works standalone with these dependencies:
- Bash 4+
- typst
- yq-go
- typstyle (for formatting)
- shfmt (for formatting)

## Architecture and File Structure

### Hybrid Content Management System

The project uses a hybrid approach separating factual data from localized content:

- **`src/profile.yaml`** - Single source of truth for all factual data (dates, companies, skills, etc.)
- **`src/locales/{lang}.yaml`** - Language-specific translations (titles, descriptions, objectives)
- **`src/languages.yaml`** - Central language configuration and metadata
- **`src/i18n.yaml`** - UI strings and section headers for each language

### Key Components

- **`src/cv.typ`** - Main entry point, handles language parameters, data composition, and template instantiation
- **`src/sections.typ`** - Section rendering functions for experience, education, certifications, sidebar
- **`templates/vantage/main.typ`** - Template definition with theme configuration and layout
- **`bin/cv`** - Shell script providing development workflow commands

### Data Flow Architecture

1. **Language Resolution**: `cv.typ` receives language parameter, validates against available languages
2. **Data Loading**: Base profile loaded from `profile.yaml`, language-specific content from `locales/{lang}.yaml`
3. **Data Composition**: Merge functions combine factual data with localized content using ID-based mapping
4. **Template Rendering**: Composed configuration passed to Vantage template for PDF generation

### Content ID System

All factual entities (jobs, education, certifications) use unique IDs for cross-language consistency:
- Jobs: `jobs.{id}` maps base facts to `locales.jobs.{id}` translations
- Education: `education.{id}` maps to `locales.education.{id}`
- Languages/References: Similar ID-based mapping pattern

## Quality Checks & Testing

Use `nix flake check` to run all checks (format + build for all languages).

For manual validation:
- `nix fmt` - Format all Typst and shell files
- `nix run . -- validate` - Check data consistency and file structure
- `nix build .#cv-all` - Full build test for all languages

## Output

Generated PDFs are placed in `out/...-{lang}.pdf` format.
