$progs=@(
    "Git.Git"
    "Brave.Brave"
    "glzr-io.glazewm"
    "JanDeDobbeleer.OhMyPosh"
    "junegunn.fzf"
    "Neovim.Neovim"
    "BurntSushi.ripgrep.MSVC"
    "Microsoft.PowerToys"
    #"Fastfetch-cli.Fastfetch"
    #"magic-wormhole.magic-wormhole"
)

foreach ($prog in $progs) {
    winget install --silent --accept-source-agreements --accept-package-agreements --id $prog
}
