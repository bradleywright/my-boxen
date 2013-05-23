class people::bradleywright {
  include adium
  include alfred
  include caffeine
  include chrome
  include dropbox
  include emacs::formacosx
  include iterm2::dev
  include omnifocus
  include remove-spotlight
  include skype
  include slate
  include turn-off-dashboard
  include zsh

  # OSX hacks
  include osx::disable_app_quarantine
  include osx::dock::autohide
  include osx::finder::unhide_library
  include osx::global::disable_key_press_and_hold
  include osx::global::enable_keyboard_control_access
  include osx::global::expand_save_dialog
  include osx::no_network_dsstores

  class { 'osx::global::key_repeat_delay':
    delay => 300
  }

  boxen::osx_defaults { 'Disable reopen windows when logging back in':
    key    => 'TALLogoutSavesState',
    domain => 'com.apple.loginwindow',
    value  => 'false',
    user   => $::boxen_user,
  }

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
    content => "(exec-path-from-shell-copy-envs '(\"BOXEN_NVM_DIR\" \"BOXEN_NVM_DEFAULT_VERSION\"))
",
    require => Repository[$emacs],
  }

  package {
    [
     'bash-completion',
     'coreutils',
     'gnu-typist',
     'python',
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
    content => "[[ -f ${boxen::config::boxen_home}/env.sh ]] && . ${boxen::config::boxen_home}/env.sh"
  }

  file { "${my_home}/.localgitconfig":
    mode    => '0644',
    content => "[user]
    email = brad@intranation.com
[credential]
    helper = osxkeychain",
  }
}
