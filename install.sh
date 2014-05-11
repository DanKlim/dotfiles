dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# bash
ln -s "$dir"/bash/.bash_profile ~
ln -s "$dir"/bash/.bashrc ~
ln -s "$dir"/bash/.alias ~

# Only needed if you'll use mongo shell.
ln -s "$dir"/bash/mongo.js ~

# I love vim
ln -s "$dir"/vim/.vimrc ~
ln -s "$dir"/vim/.gvimrc ~
ln -s "$dir"/vim/shared.vim ~/.vim
ln -s "$dir"/vim/mybundle.vim ~/.vim

# jshint
ln -s "$dir"/.jshintrc ~

# keyboard mappings
# https://pqrs.org/macosx/keyremap4macbook/
ln -s "$dir"/private.xml ~
ln -s "$dir"/keyboard ~
ln -s "$dir"/keyboard/.slate.js ~
ln -s "$dir"/keyboard/.phoenix ~
ln -s "$dir"/keyboard/.zephyros.js ~
