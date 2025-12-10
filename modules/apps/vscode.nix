{ config, pkgs, ... }:

let
  inherit (config.aster) user;

  languageServers = with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
    esbenp.prettier-vscode
    rust-lang.rust-analyzer
  ];

  githubExtensions = with pkgs.vscode-extensions.github; [
    copilot
    copilot-chat
    codespaces
    vscode-github-actions
    vscode-pull-request-github
  ];

  cDevExtensions = with pkgs.vscode-extensions; [
    ms-vscode.cpptools-extension-pack
    ms-vscode.makefile-tools
    llvm-vs-code-extensions.vscode-clangd
  ];

  miscExtensions = with pkgs.vscode-extensions; [
    pkief.material-icon-theme
    usernamehw.errorlens
    mkhl.direnv
    gruntfuggly.todo-tree
  ];

  manualExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
    name = "sftp";
    publisher = "natizyskunk";
    version = "1.16.3";
    sha256 = "sha256-HifPiHIbgsfTldIeN9HaVKGk/ujaZbjHMiLAza/o6J4=";
  }];

  vscodeExtended = pkgs.vscode-with-extensions.override {
    inherit (pkgs) vscode;
    vscodeExtensions = builtins.concatLists [
      languageServers
      githubExtensions
      cDevExtensions
      miscExtensions
      manualExtensions
    ];
  };

  cDevSettings = {
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
  };

  editorSettings = {
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
  };

  explorerSettings = {
    "explorer.compactFolders" = false;
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
  };

  extensionSettings = {
    "errorLens.gutterIconsEnabled" = true;
    "errorLens.messageBackgroundMode" = "message";
    "direnv.restart.automatic" = true;
  };

  filesSettings = {
    "files.autoSave" = "onWindowChange";
    "files.insertFinalNewline" = true;
    "files.trimTrailingWhitespace" = true;
  };

  langSettings = {
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nil";
    "nix.serverSettings"."nil"."formatting"."command" = [ "nixfmt" ];

    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
      "editor.formatOnSave" = true;
    };

    "rust-analyzer.server.path" = "rust-analyzer";
  };

  telemetrySettings = {
    "redhat.telemetry.enabled" = false;
    "telemetry.telemetryLevel" = "off";
    "extensions.autoCheckUpdates" = false;
    "extensions.autoUpdate" = false;
    "update.mode" = "none";
    "update.showReleaseNotes" = false;
  };

  windowSettings = {
    "window.dialogStyle" = "custom";
    "window.menuBarVisibility" = "toggle";
    "window.titleBarStyle" = "custom";
  };

  workbenchSettings = {
    "workbench.colorTheme" = "Default Dark+";
    "workbench.editor.empty.hint" = "hidden";
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.layoutControl.enabled" = false;
    "workbench.startupEditor" = "none";
  };

  terminalSettings = {
    "terminal.integrated.fontFamily" = "'monospace'";
    "terminal.integrated.gpuAcceleration" = "on";
  };

  allSettings = cDevSettings // editorSettings // explorerSettings
    // extensionSettings // filesSettings // langSettings // telemetrySettings
    // windowSettings // workbenchSettings // terminalSettings;

  settings = builtins.toJSON allSettings;
in {
  users.users.${user}.packages = [
    vscodeExtended
    pkgs.nil
    pkgs.nixfmt-classic
    pkgs.statix
    pkgs.deadnix
    pkgs.bat
  ];

  hjem.users.${user}.files.".config/Code/User/settings.json".text = settings;
}
