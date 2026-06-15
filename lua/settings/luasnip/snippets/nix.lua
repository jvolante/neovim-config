local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

-- Builds a `types.<type>` choice node at the given jump index.
-- Includes the most common NixOS option types.
local function type_choice(idx)
  return c(idx, {
    t("types.str"),
    t("types.int"),
    t("types.bool"),
    t("types.port"),
    t("types.path"),
    t("types.package"),
    sn(nil, { t("types.listOf "), i(1, "types.str") }),
    sn(nil, { t("types.attrsOf "), i(1, "types.str") }),
    sn(nil, { t("types.nullOr "), i(1, "types.str") }),
    sn(nil, { t("types.enum [ "), i(1), t(" ]") }),
  })
end

ls.add_snippets('nix', {

  -- ── Flakes ──────────────────────────────────────────────────────────────

  -- Leaf / application flake: the most common skeleton for a single package
  -- repo. Uses flake-utils eachDefaultSystem, a single package, and a devShell.
  s({ trig = "flake-leaf", dscr = "Leaf project flake with one package and devShell" },
    fmta([[
{
  description = "<desc>";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        <pkg> = pkgs.callPackage ./package.nix { };
      in
      {
        packages = {
          <pkg2> = <pkg3>;
          default = <pkg4>;
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ <pkg5> ];
          packages = with pkgs; [ <devpkgs> ];
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
]], {
      desc    = i(1, "A flake"),
      pkg     = i(2, "myPackage"),
      pkg2    = rep(2),
      pkg3    = rep(2),
      pkg4    = rep(2),
      pkg5    = rep(2),
      devpkgs = i(3, "git"),
    })),

  -- Overlay flake: exposes an overlay and legacyPackages for downstream use.
  s({ trig = "flake-overlay", dscr = "Overlay flake with legacyPackages and overlay output" },
    fmta([[
{
  description = "<desc>";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }@flakeInputs:
    let
      overlay = final: prev: {
        <body>
      };

      pkgsForSystem =
        system:
        import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = pkgsForSystem system;
      in
      {
        legacyPackages = pkgs;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ <devpkgs> ];
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    )
    // {
      overlays.default = overlay;
    };
}
]], {
      desc    = i(1, "An overlay flake"),
      body    = isn(2, { i(1) }, "$PARENT_INDENT        "),
      devpkgs = i(3, "git"),
    })),

  -- NixOS / home-manager system flake
  s({ trig = "flake-system", dscr = "NixOS system configuration flake" },
    fmta([[
{
  description = "<desc>";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
    }:
    {
      nixosConfigurations.<host> = nixpkgs.lib.nixosSystem {
        system = "<system>";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.<user> = import ./home.nix;
          }
        ];
      };
    };
}
]], {
      desc   = i(1, "NixOS system configuration"),
      host   = i(2, "hostname"),
      system = c(3, { t("x86_64-linux"), t("aarch64-linux"), t("aarch64-darwin"), t("x86_64-darwin") }),
      user   = i(4, "username"),
    })),

  -- ── Overlays ─────────────────────────────────────────────────────────────

  -- Bare overlay function signature
  s({ trig = "overlay", dscr = "Nixpkgs overlay: final: prev: { ... }" },
    fmta([[
final: prev: {
  <body>
}
]], {
      body = isn(1, { i(1) }, "$PARENT_INDENT  "),
    })),

  -- overrideScope for namespaced package sets
  s({ trig = "override-scope", dscr = "prev.attrset.overrideScope" },
    fmta([[
<set>.overrideScope (
  finalScope: prevScope: {
    <body>
  }
)]], {
      set  = i(1, "prev.python3Packages"),
      body = isn(2, { i(1) }, "$PARENT_INDENT    "),
    })),

  -- composeManyExtensions
  s({ trig = "compose-overlays", dscr = "lib.composeManyExtensions [ ... ]" },
    fmta([[
lib.composeManyExtensions [
  <first>
  <second>
]
]], {
      first  = isn(1, { i(1) }, "$PARENT_INDENT  "),
      second = isn(2, { i(1) }, "$PARENT_INDENT  "),
    })),

  -- ── Package definitions ──────────────────────────────────────────────────

  -- stdenv.mkDerivation with finalAttrs and idiomatic structure
  s({ trig = "mkd", dscr = "stdenv.mkDerivation with finalAttrs" },
    fmta([[
stdenv.mkDerivation (finalAttrs: {
  pname = "<pname>";
  version = "<version>";

  src = <src>;

  nativeBuildInputs = [
    <native>
  ];

  buildInputs = [
    <build>
  ];

  <checks>

  meta = {
    description = "<desc>";
    homepage = "<homepage>";
    license = lib.licenses.<license>;
    maintainers = with lib.maintainers; [ <maintainers> ];
    mainProgram = "<mainprog>";
  };
})]], {
      pname       = i(1, "my-package"),
      version     = i(2, "0.1.0"),
      src         = c(3, {
        sn(nil, {
          t("fetchFromGitHub {"),
          t({ "", '  owner = "' }), i(1, "owner"), t('";'),
          t({ "", '  repo = "' }), i(2, "repo"), t('";'),
          t({ "", '  rev = "' }), i(3, "v${finalAttrs.version}"), t('";'),
          t({ "", '  hash = "' }), i(4, "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="), t('";'),
          t({ "", "};" }),
        }),
        t("./src"),
      }),
      native      = isn(4, { i(1) }, "$PARENT_INDENT    "),
      build       = isn(5, { i(1) }, "$PARENT_INDENT    "),
      checks      = c(6, {
        sn(nil, {
          t({ "doCheck = true;", "", "checkPhase = ''", "  runHook preCheck", "  " }),
          i(1, "# run tests"),
          t({ "", "  runHook postCheck", "'';" }),
        }),
        t("doCheck = false;"),
      }),
      desc        = i(7, "A description"),
      homepage    = i(8, "https://example.com"),
      license     = i(9, "mit"),
      maintainers = i(10),
      mainprog    = i(11, "my-package"),
    })),

  -- CMake + ninja package (most common C++ pattern)
  s({ trig = "cmake-pkg", dscr = "stdenv.mkDerivation for a CMake/Ninja C++ package" },
    fmta([[
stdenv.mkDerivation (finalAttrs: {
  pname = "<pname>";
  version = "<version>";

  src = <src>;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    <native>
  ];

  buildInputs = [
    <build>
  ];

  cmakeFlags = [
    <flags>
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ctest --output-on-failure --test-dir . -j$NIX_BUILD_CORES
    runHook postCheck
  '';

  separateDebugInfo = true;

  meta = {
    description = "<desc>";
    license = lib.licenses.<license>;
    mainProgram = "<mainprog>";
  };
})]], {
      pname    = i(1, "my-package"),
      version  = i(2, "0.1.0"),
      src      = i(3, "./src"),
      native   = isn(4, { i(1) }, "$PARENT_INDENT    "),
      build    = isn(5, { i(1) }, "$PARENT_INDENT    "),
      flags    = isn(6, { i(1) }, "$PARENT_INDENT    "),
      desc     = i(7, "A description"),
      license  = i(8, "mit"),
      mainprog = i(9, "my-package"),
    })),

  -- buildPythonPackage with pyproject.toml version extraction
  s({ trig = "py-pkg", dscr = "buildPythonPackage from pyproject.toml source" },
    fmta([[
buildPythonPackage {
  pname = "<pname>";
  version = (builtins.fromTOML (builtins.readFile "<src>/pyproject.toml")).project.version;
  pyproject = true;

  src = <src2>;

  build-system = [
    <buildsystem>
  ];

  dependencies = [
    <deps>
  ];

  pythonImportsCheck = [ "<pname2>" ];

  meta = {
    description = "<desc>";
    license = lib.licenses.<license>;
  };
}]], {
      pname       = i(1, "my-package"),
      src         = i(2, "./src"),
      src2        = rep(2),
      buildsystem = c(3, {
        sn(nil, { isn(nil, { t("hatchling") },    "$PARENT_INDENT    ") }),
        sn(nil, { isn(nil, { t("setuptools") },   "$PARENT_INDENT    ") }),
        sn(nil, { isn(nil, { t("flit-core") },    "$PARENT_INDENT    ") }),
        sn(nil, { isn(nil, { t("poetry-core") },  "$PARENT_INDENT    ") }),
      }),
      deps        = isn(4, { i(1) }, "$PARENT_INDENT    "),
      pname2      = rep(1),
      desc        = i(5, "A description"),
      license     = i(6, "mit"),
    })),

  -- ── Dev shells ───────────────────────────────────────────────────────────

  -- Standard mkShell using inputsFrom
  s({ trig = "mkshell", dscr = "pkgs.mkShell with inputsFrom" },
    fmta([[
pkgs.mkShell {
  inputsFrom = [ <pkg> ];
  packages = with pkgs; [
    <extras>
  ];
  <hook>
}]], {
      pkg    = i(1, "myPackage"),
      extras = isn(2, { i(1) }, "$PARENT_INDENT    "),
      hook   = c(3, {
        t(""),
        sn(nil, {
          t({ "shellHook = ''", "    " }),
          i(1),
          t({ "", "  '';" }),
        }),
      }),
    })),

  -- ── NixOS modules ────────────────────────────────────────────────────────

  -- Full NixOS module skeleton — the dominant pattern
  s({ trig = "nixos-module", dscr = "Full NixOS module with options and config" },
    fmta([[
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.services.<namespace>.<name>;
in
{
  options.services.<namespace2>.<name2> = {
    enable = mkEnableOption "<namedesc>";

    <options>
  };

  config = mkIf cfg.enable {
    <configbody>
  };
}]], {
      namespace  = i(1, "myapp"),
      name       = i(2, "service-name"),
      namespace2 = rep(1),
      name2      = rep(2),
      namedesc   = i(3, "the service"),
      options    = isn(4, { i(1) }, "$PARENT_INDENT    "),
      configbody = isn(5, { i(1) }, "$PARENT_INDENT    "),
    })),

  -- systemd service block
  s({ trig = "systemd-service", dscr = "systemd.services.<name> = { ... } block" },
    fmta([[
systemd.services.<name> = {
  description = "<desc>";
  wantedBy = [ "multi-user.target" ];
  after = [ "network.target" ];

  serviceConfig = {
    Type = "simple";
    ExecStart = "<execstart>";
    Restart = "on-failure";
    RestartSec = 5;
    User = <user>;
    DynamicUser = <dynuser>;
    StateDirectory = "<statedir>";
    LogsDirectory = "<logsdir>";
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
  };
};]], {
      name      = i(1, "my-service"),
      desc      = i(2, "My service"),
      execstart = i(3, "${pkgs.my-package}/bin/my-binary"),
      user      = c(4, { t("\"my-service\""), t("config.users.users.my-service.name") }),
      dynuser   = c(5, { t("true"), t("false") }),
      statedir  = i(6, "my-service"),
      logsdir   = i(7, "my-service"),
    })),

  -- systemd.tmpfiles.rules entries
  s({ trig = "tmpfiles", dscr = "systemd.tmpfiles.rules entries" },
    fmta([[
systemd.tmpfiles.rules = [
  "d <dir> <mode> <user> <group> - -"
  <more>
];]], {
      dir   = i(1, "/var/lib/my-service"),
      mode  = i(2, "0750"),
      user  = i(3, "my-service"),
      group = rep(3),
      more  = isn(4, { i(1) }, "$PARENT_INDENT  "),
    })),

  -- mkOption with type choice node
  s({ trig = "mkoption", dscr = "mkOption { type; default; description; }" },
    fmta([[
<name> = mkOption {
  type = <type>;
  default = <default>;
  description = "<desc>";
};]], {
      name    = i(1, "optionName"),
      type    = type_choice(2),
      default = i(3),
      desc    = i(4, "Description of the option."),
    })),

  -- mkEnableOption (standalone, for when you just need one option line)
  s({ trig = "enable-option", dscr = "enable = mkEnableOption" },
    fmta([[enable = mkEnableOption "<desc>";]], {
      desc = i(1, "the service"),
    })),

  -- pkgs.formats.yaml config generation pattern
  s({ trig = "settings-format", dscr = "pkgs.formats.<fmt> config file generation" },
    fmta([[
<fmt_val> = pkgs.formats.<fmt2> { };
<cfgfile> = <fmt3>.generate "<filename>" {
  <attrs>
};]], {
      fmt_val  = i(1, "settingsFormat"),
      fmt2     = c(2, { t("yaml"), t("json"), t("toml"), t("ini") }),
      cfgfile  = i(3, "configFile"),
      fmt3     = rep(1),
      filename = i(4, "config.yaml"),
      attrs    = isn(5, { i(1) }, "$PARENT_INDENT  "),
    })),

  -- ── Common expressions ───────────────────────────────────────────────────

  -- inherit (lib) ... ; for the typical module header
  s({ trig = "inherit-lib", dscr = "inherit (lib) mkEnableOption mkOption types;" },
    fmta([[
inherit (lib)
  mkEnableOption
  mkIf
  mkOption
  types
  ;]], {})),

  -- lib.mkIf
  s({ trig = "mkif", dscr = "lib.mkIf condition value" },
    fmta([[mkIf <cond> <val>]], {
      cond = i(1, "cfg.enable"),
      val  = i(2),
    })),

  -- lib.mkMerge
  s({ trig = "mkmerge", dscr = "lib.mkMerge [ ... ]" },
    fmta([[
mkMerge [
  <first>
  <second>
]
]], {
      first  = isn(1, { i(1) }, "$PARENT_INDENT  "),
      second = isn(2, { i(1) }, "$PARENT_INDENT  "),
    })),

  -- lib.optionalAttrs
  s({ trig = "optattrs", dscr = "lib.optionalAttrs cond { ... }" },
    fmta([[lib.optionalAttrs <cond> {
  <body>
}]], {
      cond = i(1, "condition"),
      body = isn(2, { i(1) }, "$PARENT_INDENT  "),
    })),

  -- builtins.fromTOML version extraction (standalone)
  s({ trig = "from-toml-version", dscr = "Read version from pyproject.toml via builtins.fromTOML" },
    fmta([[(builtins.fromTOML (builtins.readFile "<src>/pyproject.toml")).project.version]], {
      src = i(1, "src"),
    })),

})
