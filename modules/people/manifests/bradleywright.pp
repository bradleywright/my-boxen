class people::bradleywright {
  include adium
  include alfred
  include caffeine
  include chrome
  include dropbox
  include emacs::head
  include emacs-keybindings
  include iterm2::dev
  include omnifocus
  include remove-spotlight
  include skype
  include turn-off-dashboard
  include vagrant
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
    delay => 200
  }

  class { 'osx::global::key_repeat_rate':
    rate => 400
  }

  boxen::osx_defaults { 'Disable reopen windows when logging back in':
    key    => 'TALLogoutSavesState',
    domain => 'com.apple.loginwindow',
    value  => 'false',
    user   => $::boxen_user,
  }

  $my_home  = "/Users/${::boxen_user}"

  $dotfiles = "${::boxen_srcdir}/dotfiles"

  repository { $dotfiles:
    source  => 'bradleywright/dotfiles',
    require => File[$::boxen_srcdir],
    notify  => Exec['bradleywright-make-dotfiles'],
  }

  exec { 'bradleywright-make-dotfiles':
    command     => "cd ${dotfiles} && make",
    refreshonly => true,
  }

  $emacs = "${::boxen_srcdir}/emacs-d"

  repository { $emacs:
    source  => 'bradleywright/emacs-d',
    require => File[$::boxen_srcdir],
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
     'the_silver_searcher',
     'tmux',
     'tree',
     'wget',
     'zsh-completions',
     'zsh-lovers',
     ]:
  }

  file { "${my_home}/.local_zshrc":
    mode    => '0644',
    content => "cdpath=(${::boxen_srcdir} ~)

# Do not want hub clobbering git
unalias git",
  }

  file { "${my_home}/.local_zshenv":
    mode    => '0644',
    content => "[[ -f ${boxen::config::boxen_home}/env.sh ]] && . ${boxen::config::boxen_home}/env.sh

[[ -d ${boxen::config::boxen_home}/homebrew/share/python ]] && path=(\$path ${boxen::config::boxen_home}/homebrew/share/python)
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


  # Keyboard hacks
  include keyremap4macbook
  include keyremap4macbook::login_item

  # Tap Ctrl_l for <esc>, hold for <ctrl>
  keyremap4macbook::remap{ 'controlL2controlL_escape': }
  keyremap4macbook::set{ 'parameter.keyoverlaidmodifier_timeout':
    value => '300'
  }

  keyremap4macbook::private_xml{ 'private.xml':
    source => 'puppet:///modules/people/bradleywright/private.xml'
  }

  keyremap4macbook::remap{ 'space_cadet.force_correct_shifts': }

}
