# AGENTS.md

This file provides guidance to AI Agents when working with code in this repository.

## Project Overview

This is a multilingual CV/resume generator built with Typst. It supports generating PDF resumes in multiple languages using a hybrid content management approach with localized templates.

## Development Environment

Use Nix for development environment setup:
```bash
nix develop
```

The development shell includes:
- typst (PDF compilation)
- typstyle (code formatting)
- shfmt (shell script formatting)
- yq-go (YAML processing)

## Common Commands

All development tasks are managed through the `./bin/cv` script:

```bash
# Development workflow
./bin/cv help                    # Show all available commands
./bin/cv build [lang]            # Build CV PDF (default: en, available: en es)
./bin/cv build-all               # Build CVs for all languages
./bin/cv check [lang]            # Check compilation without building
./bin/cv check-all               # Check compilation for all languages
./bin/cv validate                # Validate data consistency across languages
./bin/cv fmt                     # Format Typst and shell files
./bin/cv watch [lang]            # Watch for changes and auto-rebuild

# Testing and validation
./bin/cv check-all               # Run before commits to ensure all languages compile
./bin/cv validate                # Verify data consistency across languages
```

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

Use the built-in validation and check commands:
- Run `./bin/cv fmt` to format all Typst files using typstyle and shell scripts using shfmt
- `./bin/cv check-all` - Verify all languages compile successfully
- `./bin/cv validate` - Check data consistency and file structure
- `./bin/cv build-all` - Full build test for all languages

## Output

Generated PDFs are placed in `out/...-{lang}.pdf` format.
