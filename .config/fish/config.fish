abbr -a 'e' 'nvim'
abbr -a 'g' 'git'
abbr -a 'ga' 'git add -p'
abbr -a 'gc' 'git commit'
abbr -a 'gch' 'git checkout'
abbr -a 'll' 'ls -l'
abbr -a 'la' 'ls -a'
abbr -a 'lll' 'ls -la'

set -g fish_key_bindings fish_vi_key_bindings

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -Ux EDITOR nvim
end

function cat
    bat $argv
end

function fish_prompt
    echo
end

function fish_mode_prompt
    echo
end

function fish_greeting

end

function _git_branch_name
    echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
    echo (command git status -s --ignore-submodules=dirty 2>/dev/null)
end


functions -e fish_right_prompt; function fish_prompt --description 'Informative prompt'
    #Save the return status of the previous command
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

    switch $fish_bind_mode
	case default
	    set mode_color (set_color blue --bold)
	    set working_mode 'N'
	case insert
	    set mode_color (set_color red --bold)
	    set working_mode 'I'
	case visual
	    set mode_color (set_color green --bold)
	    set working_mode 'V'
    end

    set -l git_branch ''
    set -l git_status_color (set_color green)
    if [ (_git_branch_name) ]
	if [ (_is_git_dirty) ]
	    set git_status_color (set_color red)
	    set git_branch ': (╯°□°)╯ '(_git_branch_name)''
	else
	    set git_branch ': '(_git_branch_name)''
	end
    end
    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color --bold $fish_color_status)
    set -l pipestatus_string (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

    printf '[%s] [%s%s%s] [%s%s%s%s%s%s%s] [%s%s%s%s%s] %s%s\n%s%s%s' \
	(date "+%H:%M:%S") \
	$mode_color $working_mode (set_color normal) \
	(set_color brblue) $USER (set_color green) '@' (set_color brblue) (prompt_hostname) (set_color normal) \
	(set_color $fish_color_cwd) (command echo $PWD | sed -e 's|/home/m3ta|~|') $git_status_color $git_branch (set_color normal) \
	$pipestatus_string (set_color normal) \
	(set_color brblue) ' ~> ' (set_color normal)

end

fzf --fish | source

zoxide init --cmd j fish | source

# set -x GOPATH /storage/go
# must be configured per system as different systems may have global CARGO_HOMEs
source "$HOME/.local/share/env.fish"
set -x PATH $PATH ~/.local/bin # /opt/nvim-linux64/bin /storage/depot_tools /storage/go/bin /storage/cargo/bin

