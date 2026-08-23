{ pkgs, lib, config, ... }:

let
  nvimConfigRepo = "https://github.com/jvolante/neovim-config.git";
  nvimConfigDir  = "${config.xdg.configHome}/nvim";

  # Tools that should only be visible inside Neovim
  nvimTools = [
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

  nvimWithTools = pkgs.runCommand "neovim-with-tools" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
  } ''
    mkdir -p $out/bin
    makeWrapper ${pkgs.neovim}/bin/nvim $out/bin/nvim \
      --prefix PATH : ${lib.makeBinPath nvimTools}
    ln -s $out/bin/nvim $out/bin/vim
    ln -s $out/bin/nvim $out/bin/vi
  '';

  cloneScript = pkgs.writeShellScript "clone-nvim-config" ''
    set -euo pipefail
    export GIT_CONFIG_GLOBAL=/dev/null
    export GIT_CONFIG_SYSTEM=/dev/null
    export GIT_TERMINAL_PROMPT=0

    if [ -e "${nvimConfigDir}" ] && [ ! -d "${nvimConfigDir}/.git" ]; then
      rm -rf "${nvimConfigDir}"
    fi

    if [ ! -d "${nvimConfigDir}" ]; then
      ${pkgs.git}/bin/git -c credential.helper= clone \
        ${lib.escapeShellArg nvimConfigRepo} \
        ${lib.escapeShellArg nvimConfigDir}
    else
      if [ -z "$(${pkgs.git}/bin/git -C ${nvimConfigDir} status --porcelain)" ]; then
        ${pkgs.git}/bin/git -C ${nvimConfigDir} pull
      fi
    fi
  '';
in
{
  home.packages = [ nvimWithTools ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.shellAliases = {
    vim = "nvim";
    vi  = "nvim";
  };

  home.activation.cloneNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${cloneScript}
  '';

  systemd.user.services.clone-nvim-config = {
    Unit = {
      Description = "Clone Neovim configuration repository";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
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
}
