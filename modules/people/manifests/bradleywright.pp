class people::bradleywright {
  include zsh
  include alfred
  include chrome
  include dropbox
  include slate
  include adium
  include emacs::pretest
  include iterm2::dev

  $home     = "/Users/${::luser}"
  $projects = "${home}/Projects"

  file { $projects:
    ensure => directory,
  }

  $dotfiles = "${projects}/dotfiles"

  repository { $dotfiles:
    source  => 'bradleywright/dotfiles',
    require => File[$projects]
  }

  $emacs = "${projects}/emacs-d"

  repository { $emacs:
    source  => 'bradleywright/emacs-d',
    require => File[$projects]
  }
}
