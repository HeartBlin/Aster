{ config, lib, pkgs, ... }:

let
  cfg = config.Aster.apps.vscode;
  marketplaceExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
    name = "sftp";
    publisher = "natizyskunk";
    version = "1.16.3";
    sha256 = "sha256-HifPiHIbgsfTldIeN9HaVKGk/ujaZbjHMiLAza/o6J4=";
  }];

  userSettings = {
    # Editor
    "editor.bracketPairColorization.enabled" = true;
    "editor.cursorBlinking" = "smooth";
    "editor.cursorSmoothCaretAnimation" = "on";
    "editor.fontFamily" = "'Cascadia Code', 'monospace'";
    "editor.fontLigatures" = true;
    "editor.guide.bracketPairs" = true;
    "editor.letterSpacing" = 0.5;
    "editor.lineHeight" = 22;
    "editor.minimap.enabled" = false;
    "editor.scrollbar.horizontal" = "hidden";
    "editor.smoothScrolling" = true;
    "editor.stickyScroll.enabled" = true;
    "editor.trimAutoWhitespace" = true;
    "editor.wordWrap" = "on";

    # Explorer
    "explorer.compactFolders" = false;
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;

    # Extensions Specific
    "errorLens.gutterIconsEnabled" = true;
    "errorLens.messageBackgroundMode" = "message";
    "direnv.restart.automatic" = true;

    # Files
    "files.autoSave" = "onWindowChange";
    "files.insertFinalNewline" = true;
    "files.trimTrailingWhitespace" = true;

    # Lang Servers
    ## Nix
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nil";
    "nix.serverSettings"."nil"."formatting"."command" = [ "nixfmt" ];
    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
      "editor.formatOnSave" = true;
    };

    ## Rust
    "rust-analyzer.server.path" = "rust-analyzer";

    ## C/C++
    "C_Cpp.intelliSenseEngine" = "disabled";
    "C_Cpp.default.compilerPath" = "${pkgs.gcc}/bin/gcc";
    "[c]" = {
      "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
      "editor.formatOnSave" = true;
    };
    "[cpp]" = {
      "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
      "editor.formatOnSave" = true;
    };

    # Telemetry
    "redhat.telemetry.enabled" = false;
    "telemetry.telemetryLevel" = "off";
    "extensions.autoCheckUpdates" = false;
    "extensions.autoUpdate" = false;
    "update.mode" = "none";
    "update.showReleaseNotes" = false;

    # Window
    "window.dialogStyle" = "custom";
    "window.menuBarVisibility" = "toggle";
    "window.titleBarStyle" = "custom";

    # Workbench
    "workbench.colorTheme" = "Default Dark+";
    "workbench.editor.empty.hint" = "hidden";
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.layoutControl.enabled" = false;
    "workbench.startupEditor" = "none";

    # Terminal
    "terminal.integrated.fontFamily" = "'monospace'";
    "terminal.integrated.gpuAcceleration" = "on";
  };

in {
  options.Aster.apps.vscode.enable = lib.mkEnableOption "VS Code";

  config = lib.mkIf cfg.enable {
    users.users.${config.Aster.user}.packages = with pkgs; [
      (vscode-with-extensions.override {
        inherit vscode;
        vscodeExtensions = with vscode-extensions;
          [
            # Language Servers
            jnoortheen.nix-ide
            esbenp.prettier-vscode
            rust-lang.rust-analyzer

            # GitHub
            github.copilot
            github.copilot-chat
            github.codespaces
            github.vscode-github-actions
            github.vscode-pull-request-github

            # C/C++
            ms-vscode.cpptools-extension-pack
            ms-vscode.makefile-tools
            llvm-vs-code-extensions.vscode-clangd

            # Misc
            pkief.material-icon-theme
            usernamehw.errorlens
            mkhl.direnv
            gruntfuggly.todo-tree
          ] ++ marketplaceExtensions;
      })

      # CLI tools
      nil
      nixfmt-classic
      statix
      deadnix
      bat
    ];

    hjem.users.${config.Aster.user}.files.".config/Code/User/settings.json".text =
      builtins.toJSON userSettings;
  };
}
