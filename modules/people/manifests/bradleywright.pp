class people::bradleywright {
  include adium
  include alfred
  include caffeine
  include chrome
  include dropbox
  include emacs_keybindings
  include iterm2::dev
  include iterm2::colors::solarized_dark
  include omnifocus
  include skype
  include turn_off_dashboard
  include vagrant
  include zsh

  # OSX hacks
  include osx::disable_app_quarantine
  include osx::dock::autohide
  include osx::finder::unhide_library
  include osx::global::disable_key_press_and_hold
  include osx::global::enable_keyboard_control_access
  include osx::global::expand_save_dialog
  include osx::keyboard::capslock_to_control
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
    content => "(exec-path-from-shell-copy-envs '(\"BOXEN_NVM_DIR\" \"BOXEN_NVM_DEFAULT_VERSION\" \"GOPATH\"))
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
  include karabiner
  include karabiner::login_item

  karabiner::profile { 'Default': }

  # Tap Ctrl_l for <esc>, hold for <ctrl>
  karabiner::remap{ 'controlL2controlL_escape': }
  karabiner::set{ 'parameter.keyoverlaidmodifier_timeout':
    value => '300'
  }

  karabiner::private_xml{ 'private.xml':
    source => 'puppet:///modules/people/bradleywright/private.xml'
  }

  karabiner::remap{ 'space_cadet.force_correct_shifts': }
  karabiner::remap{ 'space_cadet.force_correct_commands': }

  include pckeyboardhack
  # add pckeyboardhack to login items
  include pckeyboardhack::login_item

  # Emacs
  package { 'Emacs':
    provider => 'appdmg',
    source   => 'http://emacsformacosx.com/emacs-builds/Emacs-pretest-24.3.91-universal-10.6.8.dmg',
    notify   => Exec['fix-emacs-termcap'],
  }

  # So ansi-term behaves itself: http://stackoverflow.com/a/8920373
  exec { 'fix-emacs-termcap':
    command     => 'tic -o \
      ~/.terminfo \
      /Applications/Emacs.app/Contents/Resources/etc/e/eterm-color.ti',
    provider    => shell,
    refreshonly => true,
  }

  file { "${boxen::config::envdir}/emacs-macosx.sh":
    content => "export PATH=/Applications/Emacs.app/Contents/MacOS/bin:\$PATH
alias emacs=/Applications/Emacs.app/Contents/MacOS/Emacs-10.7
",
    require => File[$boxen::config::envdir],
  }

}
