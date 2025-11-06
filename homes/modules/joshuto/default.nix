{
  lib,
  pkgs,
  ...
}: {
  home.packages = [pkgs.file];
  programs.joshuto = let
    preview_script = pkgs.writeShellApplication {
      name = "joshuto-preview";
      # This might be a bit expensive to add all
      # these packages only for preview...
      runtimeInputs = with pkgs; [
        pandoc
        bat
        poppler-utils
        exiftool
        odt2txt
        pandoc
        w3m
        lynx
        elinks
        jq
        mediainfo
        exiftool
        catdoc
        mu
        djvulibre
        mupdf-headless
        catdoc
      ];
      text = lib.readFile ./preview.sh;
    };
  in {
    enable = true;
    settings = {
      preview = {
        max_preview_size = "20MB";
        use_preview_script = true;
        preview_script = "${lib.getExe preview_script}";
      };
    };
    mimetype = {
      class = {
        text_default = [{command = "nvim";}];
      };
      mimetype.text = {
        "inherit" = "text_default";
      };
      extension = let
        inherit_default = inherit_mime: extensions:
          lib.listToAttrs (
            lib.forEach extensions
            (e: {
              name = e;
              value = {"inherit" = inherit_mime;};
            })
          );
      in
        (inherit_default "text_default" [
          "build"
          "c"
          "cmake"
          "conf"
          "cpp"
          "css"
          "csv"
          "cu"
          "ebuild"
          "eex"
          "env"
          "ex"
          "exs"
          "go"
          "h"
          "hpp"
          "hs"
          "html"
          "ini"
          "java"
          "js"
          "json"
          "kt"
          "log"
          "lua"
          "md"
          "micro"
          "ninja"
          "nix"
          "norg"
          "org"
          "py"
          "rkt"
          "rs"
          "scss"
          "sh"
          "srt"
          "svelte"
          "toml"
          "tsx"
          "txt"
          "vim"
          "xml"
          "yaml"
          "yml"
        ])
        // (inherit_default "video_default" ["mkv"]);
    };
  };

  programs.zsh = {
    initExtra = lib.mkAfter ''
      # Add ctrl+N shortcut to navigate with joshuto and zsh
      function _joshuto() {
        ID="$$"
        mkdir -p /tmp/$USER
        OUTPUT_FILE="/tmp/$USER/joshuto-cwd-$ID"
        env joshuto --output-file "$OUTPUT_FILE" $@ <$TTY
        exit_code=$?
        case "$exit_code" in
          # regular exit
          0)
            ;;
          # output contains current directory
          101)
            JOSHUTO_CWD=$(cat "$OUTPUT_FILE")
            zle && zle -I
            cd "$JOSHUTO_CWD"
            ;;
          # output selected files
          102)
            ;;
          *)
            echo "Exit code: $exit_code"
            ;;
        esac
      }

      zle -N _joshuto
      bindkey -v '^N' _joshuto
    '';
  };
}
