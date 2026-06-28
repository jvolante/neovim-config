{ pkgs, lib, config, ... }:

let
  nvimConfigRepo = "https://github.com/jvolante/nvim-config.git";
  nvimConfigDir  = "${config.xdg.configHome}/nvim";

  # Single source of truth for the clone logic
  cloneScript = pkgs.writeShellScript "clone-nvim-config" ''
    set -euo pipefail
    if [ ! -d "${nvimConfigDir}" ]; then
      ${pkgs.git}/bin/git clone \
        ${lib.escapeShellArg nvimConfigRepo} \
        ${lib.escapeShellArg nvimConfigDir}
    else
      # Pull only if we're in a clean state to avoid conflicts
      if [ -z "$(${pkgs.git}/bin/git -C ${nvimConfigDir} status --porcelain)" ]; then
        ${pkgs.git}/bin/git -C ${nvimConfigDir} pull
      fi
    fi
  '';
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;

    withNodeJs = false;
    withPerl = false;
    withPython3 = false;
    withRuby = false;

    extraPackages = [
      pkgs.tree-sitter
      pkgs.wl-clipboard
      pkgs.ripgrep
      pkgs.clang-tools
      pkgs.glsl_analyzer
      pkgs.buf
      pkgs.rust-analyzer
      pkgs.lua-language-server
      pkgs.tinymist
      pkgs.nixd
      pkgs.bash-language-server
      pkgs.shfmt
      pkgs.shellcheck
      pkgs.yaml-language-server
      pkgs.neocmakelsp
      pkgs.taplo
      pkgs.marksman
      pkgs.jq-lsp
      pkgs.jqfmt
      pkgs.harper
      pkgs.vscode-langservers-extracted
      pkgs.gnumake
      pkgs.gcc
    ];
  };

  # Systemd user service: runs once per login if the directory is missing
  systemd.user.services.clone-nvim-config = {
    Unit = {
      Description = "Clone Neovim configuration repository";
      After = [ "network.target" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = cloneScript;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Activation: ensures the clone happens during rebuild even before login
  home.activation.cloneNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if ${pkgs.systemd}/bin/systemctl --user is-system-running &>/dev/null; then
      $DRY_RUN_CMD ${pkgs.systemd}/bin/systemctl --user start clone-nvim-config.service
    else
      $DRY_RUN_CMD ${cloneScript}
    fi
  '';
}