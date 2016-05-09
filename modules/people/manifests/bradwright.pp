class people::bradwright {
  ruby::version { '2.3.0': }
  nodejs::version { '4.4.1': }

  # Null out El Capitan's zprofile so it doesn't break my path:
  # http://www.zsh.org/mla/users/2015/msg00724.html
  file { '/etc/zprofile':
    content => ''
  }

  class { 'osx::global::key_repeat_delay':
    delay => 25
  }

  class { 'osx::global::key_repeat_rate':
    rate => 2
  }

  include osx::dock::autohide
  include osx::keyboard::capslock_to_control
  include osx::global::tap_to_click

  $my_home  = "/Users/${::boxen_user}"

  $dotfiles = "${boxen::config::srcdir}/dotfiles"

  repository { $dotfiles:
    source  => 'bradwright/dotfiles',
    notify  => Exec['bradwright-make-dotfiles'],
  }

  exec { 'bradwright-make-dotfiles':
    command     => "cd ${dotfiles} && make",
    refreshonly => true,
  }

  $emacs = "${boxen::config::srcdir}/emacs.d"

  repository { $emacs:
    source  => 'bradwright/emacs.d',
    notify  => Exec['bradwright-make-emacs-d'],
  }

  exec { 'bradwright-make-emacs-d':
    command     => "cd ${emacs} && make",
    refreshonly => true,
  }

  file { "${my_home}/.local_zshrc":
    mode    => '0644',
    content => "cdpath=(${boxen::config::srcdir} ~)
"
  }

  file { "${my_home}/.local_zshenv":
    mode    => '0644',
    content => "[[ -f ${boxen::config::boxen_home}/env.sh ]] && . ${boxen::config::boxen_home}/env.sh
"
  }

  git::config::global { 'user.email':
    value => 'brad@intranation.com',
  }

  git::config::global { 'include.path':
    value => "${my_home}/.local_gitconfig",
  }

  # Use my own Git config, thanks.
  Git::Config::Global <| title == "core.excludesfile" |> {
    value => '~/.gitignore'
  }

  # OSX Emacs fixes
  package { 'Emacs':
    provider => 'appdmg',
    source   => 'http://emacsformacosx.com/emacs-builds/Emacs-pretest-25.0.91-universal.dmg',
    notify   => Exec['fix-emacs-termcap'],
  }

  file { "${boxen::config::envdir}/emacs-macosx.sh":
    content => 'export PATH=/Applications/Emacs.app/Contents/MacOS/bin:$PATH
alias emacs=/Applications/Emacs.app/Contents/MacOS/Emacs
',
    require => File[$boxen::config::envdir],
  }

  # So ansi-term behaves itself: http://stackoverflow.com/a/8920373
  exec { 'fix-emacs-termcap':
    command     => 'tic -o \
      ~/.terminfo \
      /Applications/Emacs.app/Contents/Resources/etc/e/eterm-color.ti',
    provider    => shell,
    refreshonly => true,
  }

  # Omnifocus
  package { 'OmniFocus':
    provider => 'appdmg_eula',
    source   => 'http://www.omnigroup.com/ftp1/pub/software/MacOSX/10.10/OmniFocus-2.4.2.dmg',
  }

  # Dispatch x-message protocol handler
  # http://www.dispatchapp.net/faq.html#openDispatchLinksOnMac
  package { 'Dispatch URL Helper':
    provider => 'appdmg',
    source   => 'http://www.dispatchapp.net/downloads/DispatchURLHelper.dmg',
    notify   => Exec['open_dispatch_helper_app'],
  }

  exec { 'open_dispatch_helper_app':
    command     => 'open -a "Dispatch URL Helper"',
    provider    => shell,
    refreshonly => true,
  }

  # Go
  package { 'go':
    ensure   => latest,
    provider => homebrew,
    notify   => Exec['install_go_tools'],
  }

  exec { 'install_go_tools':
    environment => ["GOPATH=${my_home}/go"],
    command     => 'go get golang.org/x/tools/cmd/godoc \
                    && go get golang.org/x/tools/cmd/vet \
                    && go get github.com/nsf/gocode \
                    && go get github.com/rogpeppe/godef',
    provider    => shell,
    refreshonly => true,
  }

  # FZF - fuzzy finder in shell
  $fzf_env_config = "${boxen::config::envdir}/fzf.sh"
  package { 'fzf':
    ensure   => latest,
    provider => homebrew,
    before   => File[$fzf_env_config],
  }

  # This is what 'install' puts into your shell - put it in directly so I can
  # avoid the interactive install
  $fzf_home = "${boxen::config::homebrewdir}/opt/fzf"
  file { "${fzf_env_config}":
    content     => "# Setup fzf
# ---------
if [[ ! \"\$PATH\" == *${fzf_home}/bin* ]]; then
  export PATH=\"\$PATH:${fzf_home}/bin\"
fi

# Man path
# --------
if [[ ! \"\$MANPATH\" == *${fzf_home}/man* && -d \"${fzf_home}/man\" ]]; then
  export MANPATH=\"\$MANPATH:${fzf_home}/man\"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source \"${fzf_home}/shell/completion.zsh\" 2> /dev/null

# Key bindings
# ------------
source \"${fzf_home}/shell/key-bindings.zsh\"

# Because I use solarized-dark, force FZF to use 16 colours
export FZF_DEFAULT_OPTS=\"--color 16\"
",
    require     => File[$boxen::config::envdir],
  }

  # Docker tab completion - for Docker Beta
  homebrew::tap { 'homebrew/completions': }
  package { 'homebrew/completions/docker-completion':
    ensure => present,
  }
}
