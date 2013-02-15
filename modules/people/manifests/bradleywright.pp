class people::bradleywright {
  include zsh

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
