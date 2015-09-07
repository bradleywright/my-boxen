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
}
