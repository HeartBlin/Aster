let
  Vega =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDTg4/5xS/Cn+V8m+5uJM/+RTQiobT/eCfdn4/9rZglY Vega";
in {
  "heart.age".publicKeys = [ Vega ]; # Guess
  "gitPersona.age".publicKeys = [ Vega ]; # [user] in git.nix
  "allowedSigner.age".publicKeys = [ Vega ]; # it does have my email technically
  "restic.age".publicKeys = [ Vega ]; # Restic backups
  "rclone.age".publicKeys = [ Vega ]; # Rclone backups
}
