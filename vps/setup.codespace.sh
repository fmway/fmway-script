#!/bin/env bash
SUDO=(sudo)
# link workspace to home
ln -sv /workspaces/* ~/

[ -d ~/.config/fish/conf.d ] || mkdir -p ~/.config/fish/conf.d
[ -d ~/.config/fish/functions ] || mkdir -p ~/.config/fish/functions

${SUDO[@]} apt update
${SUDO[@]} apt upgrade -y
${SUDO[@]} add-apt-repository ppa:neovim-ppa/unstable -y
${SUDO[@]} apt update
${SUDO[@]} apt install -y neovim python3-dev python3-pip fish build-essential clangd fzf tmux

# setup fish
${SUDO[@]} apt-add-repository ppa:fish-shell/release-3 -y
${SUDO[@]} apt update
${SUDO[@]} apt autoremove fish -y
${SUDO[@]} apt install fish -y
cat > ~/.config/fish/functions/fish_greeting.fish <<EOF
function fish_greeting
end
EOF
${SUDO[@]} usermod codespace -s /usr/bin/fish

# install font Meslo Nerd Fonts
${SUDO[@]} apt install wget fontconfig
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
cd ~/.local/share/fonts && unzip Meslo.zip && rm Meslo.zip && fc-cache -fv
cd -

# setup starship
curl -sS https://starship.rs/install.sh | sh
cat > ~/.config/fish/config.fish <<"OK MIN"
if status is-interactive
  starship init fish | source
end
OK MIN
echo "source <(starship init bash)" >> ~/.bashrc

# setup nvchad
# git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
# git clone https://github.com/NvChad/example_config ~/.config/nvim/lua/custom
git clone https://github.com/fmway/nvchad-old.git ~/.config/nvim

# setup deno
curl -fsSL https://deno.land/install.sh | sh
cat >> ~/.bashrc <<EOF
export DENO_INSTALL="\$HOME/.deno"
export PATH="\$DENO_INSTALL/bin:\$PATH"
source <(deno completions bash)
EOF
fish -c 'set -Ux DENO_INSTALL $HOME/.deno ; fish_add_path $DENO_INSTALL/bin'
mkdir -pv ~/.config/fish/completions
~/.deno/bin/deno completions fish > ~/.config/fish/completions/deno.fish

# setup fzf bash completion
git clone https://github.com/rockandska/fzf-obc ~/.local/share/fzf-obc
echo 'source $HOME/.local/share/fzf-obc/bin/fzf-obc.bash' >> ~/.bashrc

# setup rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo 'source "$HOME/.cargo/env"' >> ~/.bashrc
fish -c 'fish_add_path $HOME/.cargo/bin'

# setup tmux
cat >> ~/.tmux.conf <<EOF
set-option -g default-shell /usr/bin/fish
EOF


# setup nano
git clone https://github.com/fmway/nanorc /tmp/nanorc
cp /tmp/nanorc/nanorc ~/.nanorc
cp /tmp/nanorc/nano ~/.nano -rv
rm -rf /tmp/nanorc
