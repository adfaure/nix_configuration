{
  lib,
  pkgs,
  ...
}: {

  programs.joshuto = {
    enable = true;
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
