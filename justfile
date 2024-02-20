typst_src_dir := "./src"
typst_file_en := typst_src_dir + "/en/main.typ"

# prints this menu
default:
    @just --list

# format source tree
fmt:
    treefmt

# watch typst file
watch:
    typst watch --root {{ typst_src_dir }} {{ typst_file_en }} 'jago-cv-en.pdf'

# build pdf
build-en:
    typst compile --root {{ typst_src_dir }} {{ typst_file_en }} 'jago-cv-en.pdf'

alias build := build-en
alias pdf := build-en
alias pdf-en := build-en
