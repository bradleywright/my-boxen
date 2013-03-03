class people::bradleywright {
  include adium
  include alfred
  include caffeine
  include chrome
  include dropbox
  include emacs::pretest
  include iterm2::dev
  include remove-spotlight
  include skype
  include slate
  include turn-off-dashboard
  include zsh

  $my_home  = "/Users/${::luser}"
  $projects = "${my_home}/Projects"

  file { $projects:
    ensure => directory,
  }

  $dotfiles = "${projects}/dotfiles"

  repository { $dotfiles:
    source  => 'bradleywright/dotfiles',
    require => File[$projects],
    notify  => Exec['bradleywright-make-dotfiles'],
  }

  exec { 'bradleywright-make-dotfiles':
    command     => "cd ${dotfiles} && make",
    refreshonly => true,
  }

  $emacs = "${projects}/emacs-d"

  repository { $emacs:
    source  => 'bradleywright/emacs-d',
    require => File[$projects],
    notify  => Exec['bradleywright-make-emacs-d'],
  }

  exec { 'bradleywright-make-emacs-d':
    command     => "cd ${emacs} && make",
    refreshonly => true,
  }

  file { "${my_home}/.emacs.d/local/${::hostname}.el":
    mode    => '0644',
    content => "(exec-path-from-shell-copy-env \"BOXEN_NVM_DIR\")
(exec-path-from-shell-copy-env \"BOXEN_NVM_DEFAULT_VERSION\")
",
    require => Repository[$emacs],
  }

  package {
    [
     'bash-completion',
     'reattach-to-user-namespace',
     'tmux',
     'tree',
     'wget',
     'zsh-completions',
     'zsh-lovers',
     ]:
  }

  file { "${my_home}/.local_zshrc":
    mode    => '0644',
    content => 'cdpath=(~/Projects ~)
',
  }

  file { "${my_home}/.local_zshenv":
    mode    => '0644',
    content => "[[ -f ${boxen::config::boxen_home}/env.sh ]] && . ${boxen::config::boxen_home}/env.sh

if [ -d /Applications/Emacs.app ]; then
    path=(/Applications/Emacs.app/Contents/MacOS/bin \$path)
    alias emacs=/Applications/Emacs.app/Contents/MacOS/Emacs-10.7
fi
"
  }

  file { "${my_home}/.localgitconfig":
    mode    => '0644',
    content => "[user]
    email = brad@intranation.com
[credential]
    helper = osxkeychain",
  }
}
