export PAGER="less -R"

if [[ ! -z $(whence nvim) ]] then
	export EDITOR='nvim'
elif [[ ! -z $(whence vim) ]] then
	export EDITOR='vim'
fi
