class people::bradleywright {
  include zsh
  include alfred
  include chrome
  include dropbox
  include slate
  include adium

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
}
