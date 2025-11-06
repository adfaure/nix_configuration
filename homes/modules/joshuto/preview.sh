#!/usr/bin/env bash

set -x
IFS=$'\n'

set -o noclobber -o noglob -o nounset -o pipefail

shopt -s expand_aliases
alias exiftool='exiftool -api largefilesupport=1'

FILE_PATH=""
PREVIEW_WIDTH=10
PREVIEW_HEIGHT=10

while [ "$#" -gt 0 ]; do
    case "$1" in
        "--path")
            shift
            FILE_PATH="$1"
            ;;
        "--preview-width")
            shift
            PREVIEW_WIDTH="$1"
            ;;
        "--preview-height")
            shift
            # Export to silence shellcheck...
            export PREVIEW_HEIGHT="$1"
            ;;
    esac
    shift
done

handle_extension() {
    case "${FILE_EXTENSION_LOWER}" in
        a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
        rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)
            atool --list -- "${FILE_PATH}" && exit 0
            bsdtar --list --file "${FILE_PATH}" && exit 0
            exit 1 ;;
        rar)
            unrar lt -p- -- "${FILE_PATH}" && exit 0
            exit 1 ;;
        7z)
            7z l -p -- "${FILE_PATH}" && exit 0
            exit 1 ;;

        build|c|cmake|conf|cpp|css|csv|cu|ebuild|eex|\
        env|ex|exs|go|h|hpp|hs|ini|java|jl|js|kt|lua|lock|\
        log|micro|ninja|nix|norg|org|py|qmd|rkt|rs|scss|sh|\
        sql|srt|svelte|svg|toml|tsx|txt|vim|xml|yaml|yml|rproj)
            bat --color=always --paging=never \
                --style=plain \
                --terminal-width="${PREVIEW_WIDTH}" \
                "${FILE_PATH}" && exit 0
            cat "${FILE_PATH}" && exit 0
            exit 1 ;;

        md)
            glow --width="${PREVIEW_WIDTH}" \
                --local "${FILE_PATH}" && exit 0
            bat --color=always --paging=never \
                --style=plain \
                --terminal-width="${PREVIEW_WIDTH}" \
                "${FILE_PATH}" && exit 0
            cat "${FILE_PATH}" && exit 0
            exit 1 ;;

        pdf)
            pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - | \
                fmt -w "${PREVIEW_WIDTH}" && exit 0
            mutool draw -F txt -i -- "${FILE_PATH}" 1-10 | \
                fmt -w "${PREVIEW_WIDTH}" && exit 0
            exiftool "${FILE_PATH}" && exit 0
            exit 1 ;;

        torrent)
            transmission-show -- "${FILE_PATH}" && exit 0
            exit 1 ;;

        odt|sxw|docx)
            odt2txt "${FILE_PATH}" && exit 0
            pandoc -s -t markdown -- "${FILE_PATH}" && exit 0
            exit 1 ;;
        ods|odp)
            odt2txt "${FILE_PATH}" && exit 0
            exit 1 ;;

        xlsx)
            xlsx2csv -- "${FILE_PATH}" && exit 0
            exit 1 ;;

        htm|html|xhtml)
            w3m -dump "${FILE_PATH}" && exit 0
            lynx -dump -- "${FILE_PATH}" && exit 0
            elinks -dump "${FILE_PATH}" && exit 0
            pandoc -s -t markdown -- "${FILE_PATH}" && exit 0
            exit 1 ;;

        json|ipynb)
            jq --color-output . "${FILE_PATH}" && exit 0
            python -m json.tool -- "${FILE_PATH}" && exit 0
            exit 1 ;;

        dff|dsf|wv|wvc)
            mediainfo "${FILE_PATH}" && exit 0
            exiftool "${FILE_PATH}" && exit 0
            exit 1 ;;

        avif|bmp|gif|heic|jpeg|jpe|jpg|jxl|kra|pgm|png|ppm|\
        psd|tiff|webp|xcf)
            exiftool "${FILE_PATH}" && exit 0
            exit 1 ;;

        aac|ac3|aiff|ape|av1|avi|dts|flac|flv|m4a|m4v|mkv|mov|\
        mp3|mp4|oga|ogg|opus|ts|wav|webm|wmv)
            mediainfo "${FILE_PATH}" && exit 0
            exit 1 ;;

    esac
}

handle_mime() {
    local mimetype="${1}"

    case "${mimetype}" in
        text/rtf|*msword)
            catdoc -- "${FILE_PATH}" && exit 0
            exit 1 ;;

        *wordprocessingml.document|*/epub+zip|*/x-fictionbook+xml)
            pandoc -s -t markdown -- "${FILE_PATH}" | bat -l markdown \
                --color=always --paging=never \
                --style=plain \
                --terminal-width="${PREVIEW_WIDTH}" && exit 0
            exit 1 ;;

        message/rfc822)
            mu view -- "${FILE_PATH}" && exit 0
            exit 1 ;;

        *ms-excel)
            xls2csv -- "${FILE_PATH}" && exit 0
            exit 1 ;;

        text/* | */xml)
            bat --color=always --paging=never \
                --style=plain \
                --terminal-width="${PREVIEW_WIDTH}" \
                "${FILE_PATH}" && exit 0
            cat "${FILE_PATH}" && exit 0
            exit 1 ;;

        image/vnd.djvu)
            djvutxt "${FILE_PATH}" | fmt -w "${PREVIEW_WIDTH}" && exit 0
            exiftool "${FILE_PATH}" && exit 0
            exit 1 ;;

        image/*)
            exiftool "${FILE_PATH}" && exit 0
            exit 1 ;;

        video/* | audio/*)
            mediainfo "${FILE_PATH}" && exit 0
            exiftool "${FILE_PATH}" && exit 0
            exit 1 ;;
    esac
}

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"
handle_extension
MIMETYPE="$( file --dereference --brief --mime-type -- "${FILE_PATH}" )"
handle_mime "${MIMETYPE}"

exit 1
