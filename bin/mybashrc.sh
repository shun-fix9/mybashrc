mybashrc(){
	[ -z "$PS1" ] && return

	mybashrc_load_file /etc/bashrc
	mybashrc_load_file ~/.mybashrc
	mybashrc_main
}
mybashrc_main(){
	mybashrc_umask
	mybashrc_path
	mybashrc_history_options
	mybashrc_editor
	mybashrc_rails_devel_name
	mybashrc_completion
	mybashrc_ruby
	mybashrc_doctrl

	mybashrc_checkwinsize
	mybashrc_lesspipe

	mybashrc_alias

	mybashrc_prompt

	mybashrc_local
}
mybashrc_umask(){
	umask 002
}
mybashrc_path(){
	if [ -d $HOME/plugins ]; then
		for plugins_path in $HOME/plugins/*/bin; do
			if [ -d $plugins_path ]; then
				PATH=$PATH:$plugins_path
			fi
		done
	fi

	export PATH=$PATH:$HOME/bin
}
mybashrc_history_options(){
	export HISTCONTROL=ignoredups
	export HISTCONTROL=ignoreboth
}
mybashrc_checkwinsize(){
	shopt -s checkwinsize
}
mybashrc_editor(){
	export EDITOR=vim
	export SVN_EDITOR=vim
}
mybashrc_rails_devel_name(){
	export RAILS_DEVEL_NAME=$(basename $HOME)
}
mybashrc_completion(){
	mybashrc_load_file /etc/bash_completion
}
mybashrc_ruby(){
	if [ -d $HOME/.rbenv ]; then
		export PATH="$HOME/.rbenv/bin:$PATH"
		eval "$(rbenv init -)"
	fi
}
mybashrc_doctrl(){
	eval "$(cat /etc/docker-env | grep DOCTRL_ | sed 's/^/export /')"
	export DOCKER_HOST=$DOCTRL_DOCKER_HOST
	export DOCKER_API_VERSION=$DOCTRL_DOCKER_API_VERSION
	export DOCTRL_EXEC_TO=$DOCTRL_EXEC_TO
}
mybashrc_lesspipe(){
	[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
}
mybashrc_alias(){
	alias rm='rm -i'
	alias cp='cp -i'
	alias mv='mv -i'

	alias ls='ls --color=auto'
	alias ll='ls -l'
	alias la='ls -Al'
	alias lA='ls -al'

	alias grep='grep --color=auto'

	alias s='git status-verbose'
	alias a='git add -A'
	alias c='git commit -m'
	alias x='git checkout -b fix'
	alias pub='git pub'
	alias post='git post'

	alias p=connect-to-host
}
mybashrc_prompt(){
	mybashrc_prompt_color_names

	mybashrc_prompt_format

	PROMPT_COMMAND='mybashrc_prompt_command'
}
mybashrc_local(){
	: # override this for local setting
}

mybashrc_is_product() {
	is_product=1
}
mybashrc_project_root_dir_list() {
	: # project_root_dir_list=( project/root/dir )
}
mybashrc_prompt_format(){
	PROMPT_COLOR=32
	WINDOW_TITLE=""
	PS1='\[\e[${PROMPT_COLOR}m\][\u@\h.${WINDOW_TITLE} \W]\$\[\e[00m\] '
}

mybashrc_disable_change_window_title() {
	: # disabled=1 ( disable change window title )
}

mybashrc_prompt_color_names() {
	mybashrc_prompt_color_GREEN=32
	mybashrc_prompt_color_HIGH_GREEN="1;32"
	mybashrc_prompt_color_BLUE="34"
	mybashrc_prompt_color_HIGH_BLUE="1;34"
	mybashrc_prompt_color_SKY=36
	mybashrc_prompt_color_HIGH_SKY="1;36"

	mybashrc_prompt_color_RED=31
	mybashrc_prompt_color_HIGH_RED="1;31"
	mybashrc_prompt_color_PURPLE=35
	mybashrc_prompt_color_HIGH_PURPLE="1;35"
	mybashrc_prompt_color_YELLOW=33
	mybashrc_prompt_color_HIGH_YELLOW="1;33"
}
mybashrc_prompt_color_home() {
	PROMPT_COLOR=$mybashrc_prompt_color_GREEN
}
mybashrc_prompt_color_default() {
	PROMPT_COLOR=$mybashrc_prompt_color_HIGH_GREEN
}
mybashrc_prompt_color_project() {
	PROMPT_COLOR=$mybashrc_prompt_color_SKY
}
mybashrc_prompt_color_product_home() {
	PROMPT_COLOR=$mybashrc_prompt_color_YELLOW
}
mybashrc_prompt_color_product_default() {
	PROMPT_COLOR=$mybashrc_prompt_color_HIGH_RED
}
mybashrc_prompt_color_product_project() {
	PROMPT_COLOR=$mybashrc_prompt_color_RED
}

mybashrc_window_title_home() {
	WINDOW_TITLE=home
}
mybashrc_window_title_project() {
	WINDOW_TITLE=`basename $project_root_dir`
}
mybashrc_window_title_default() {
	WINDOW_TITLE=dev
}
mybashrc_window_title_product_home() {
	WINDOW_TITLE=HOME
}
mybashrc_window_title_product_project() {
	WINDOW_TITLE=`basename $project_root_dir`
}
mybashrc_window_title_product_default() {
	WINDOW_TITLE=PRODUCT
}

mybashrc_prompt_command(){
	local -a project_root_dir_list; mybashrc_project_root_dir_list

	mybashrc_change_prompt_color
	mybashrc_change_window_title

	local disabled; mybashrc_disable_change_window_title
	if [ -z "$disabled" ]; then
		# screen or screen-256color
		if [ "${TERM:0:6}" = "screen" ]; then
			echo -ne "\ek${WINDOW_TITLE}\e\\"
		else
			echo -ne "\e]0;${WINDOW_TITLE}\007"
		fi
	fi
}
mybashrc_change_prompt_color(){
	local project_root_dir

	case "$PWD" in
		"$HOME" | "$HOME"/* )
			mybashrc_prompt_color home
			return
			;;
	esac

	for project_root_dir in ${project_root_dir_list[*]}; do
		case "$PWD" in
			"$project_root_dir" | "$project_root_dir"/* )
				mybashrc_prompt_color project
				return
				;;
		esac
	done

	project_root_dir=""
	mybashrc_prompt_color default
}
mybashrc_prompt_color(){
	local name; name=$1
	local is_product
	mybashrc_is_product
	if [ -z "$is_product" ]; then
		mybashrc_prompt_color_$name
	else
		mybashrc_prompt_color_product_$name
	fi
}

mybashrc_change_window_title(){
	local project_root_dir

	case "$PWD" in
		"$HOME" | "$HOME"/* )
			mybashrc_window_title home
			return
			;;
	esac

	for project_root_dir in ${project_root_dir_list[*]}; do
		case "$PWD" in
			"$project_root_dir" | "$project_root_dir"/* )
				mybashrc_window_title project
				return
				;;
		esac
	done

	project_root_dir=""
	mybashrc_window_title default
}
mybashrc_window_title(){
	local name; name=$1
	local is_product
	mybashrc_is_product
	if [ -z "$is_product" ]; then
		mybashrc_window_title_$name
	else
		mybashrc_window_title_product_$name
	fi
}

mybashrc_load_file(){
	[ -f "$1" ] && . $1
}

mybashrc
