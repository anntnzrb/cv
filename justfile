typst_src_dir := "./src"
typst_file_en := "en/main.typ"

# prints this menu
default:
    @just --list

# build pdf
build-en:
    ./bin/compile-cv.sh --src={{ typst_src_dir }} --input={{ typst_file_en }} --output="annt-cv_en.pdf"

# watch typst file
watch:
    typst watch --root {{ typst_src_dir }} {{ typst_file_en }} 'annt-cv_en.pdf'

# format source tree
fmt:
    treefmt

# aliases

alias build := build-en
alias pdf := build-en
alias pdf-en := build-en
