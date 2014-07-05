dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# bash
ln -sf "$dir"/bash/.bash_profile ~
ln -sf "$dir"/bash/.bashrc ~
ln -sf "$dir"/bash/.alias ~

# Only needed if you'll use mongo shell.
ln -sf "$dir"/bash/mongo.js ~

# I love vim
ln -sf "$dir"/vim/.vimrc ~
ln -sf "$dir"/vim/.gvimrc ~
ln -sf "$dir"/vim/shared.vim ~/.vim
ln -sf "$dir"/vim/mybundle.vim ~/.vim

# jshint
ln -sf "$dir"/.jshintrc ~

# keyboard shortcuts
ln -sf "$dir"/private.xml "$HOME/Library/Application Support/KeyRemap4MacBook"
cp -R "$dir"/Scripts/* ~/Library/Scripts

# window management
ln -sf "$dir"/keyboard ~
ln -sf "$dir"/keyboard/.slate.js ~
ln -sf "$dir"/keyboard/.phoenix ~
ln -sf "$dir"/keyboard/.zephyros.js ~
ln -sf "$dir"/keyboard/hydra/* ~/.hydra
