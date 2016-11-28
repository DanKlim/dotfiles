dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# bash
ln -sf "$dir"/bash/.bash_profile ~
ln -sf "$dir"/bash/.bashrc ~
ln -sf "$dir"/bash/.alias ~

# For mongo shell.
ln -sf "$dir"/bash/mongo.js ~

# vim vim vim
ln -sf "$dir"/vim/.vimrc ~
ln -sf "$dir"/vim/.gvimrc ~
mkdir -p ~/.vim
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/swp
mkdir -p ~/.vim/backup
ln -sf "$dir"/vim/shared.vim ~/.vim
ln -sf "$dir"/vim/plugins.vim ~/.vim
ln -sf "$dir"/vim/.editorconfig ~/.vim

# jshint
ln -sf "$dir"/.jshintrc ~

# keyboard shortcuts
mkdir -p ~/Library/Scripts
cp -R "$dir"/Scripts/* ~/Library/Scripts

# key remap
ln -sf "$dir"/keyboard/karabiner-elements/karabiner.json ~/.karabiner.d/configuration

# window management
ln -sf "$dir"/keyboard ~
ln -sf "$dir"/keyboard/.slate.js ~
ln -sf "$dir"/keyboard/.phoenix ~
ln -sf "$dir"/keyboard/.zephyros.js ~
ln -sf "$dir"/keyboard/.mjolnir ~
ln -sf "$dir"/keyboard/.hammerspoon ~

# tmux
ln -sf "$dir"/.tmux.conf ~

echo done
