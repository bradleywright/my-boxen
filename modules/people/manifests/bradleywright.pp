class people::bradleywright {
  include zsh

  $my_home  = "/Users/${::boxen_user}"

  file { "${::boxen_srcdir}/boxen":
    ensure => 'link',
    target => "${::boxen_home}/repo"
  }

  $dotfiles = "${::boxen_srcdir}/dotfiles"

  repository { $dotfiles:
    source  => 'bradleywright/dotfiles',
    notify  => Exec['bradleywright-make-dotfiles'],
  }

  exec { 'bradleywright-make-dotfiles':
    command     => "cd ${dotfiles} && make",
    refreshonly => true,
  }

  $emacs = "${::boxen_srcdir}/emacs.d"

  repository { $emacs:
    source  => 'bradleywright/emacs.d',
    notify  => Exec['bradleywright-make-emacs-d'],
  }

  exec { 'bradleywright-make-emacs-d':
    command     => "cd ${emacs} && make",
    refreshonly => true,
  }

  file { "${my_home}/.local_zshrc":
    mode    => '0644',
    content => "cdpath=(${::boxen_srcdir} ~)
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
    value => "~/.gitignore"
  }

  # OSX Emacs fixes
  package { 'Emacs':
    provider => 'appdmg',
    source   => 'http://emacsformacosx.com/emacs-builds/Emacs-24.5-1-universal.dmg',
    notify   => Exec['fix-emacs-termcap'],
  }

  file { "${boxen::config::envdir}/emacs-macosx.sh":
    content => "export PATH=/Applications/Emacs.app/Contents/MacOS/bin:\$PATH
alias emacs=/Applications/Emacs.app/Contents/MacOS/Emacs
",
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

}
