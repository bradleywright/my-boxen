class people::bradleywright {
  include adium
  include alfred
  include chrome
  include dropbox
  include emacs::pretest
  include iterm2::dev
  include slate
  include remove-spotlight
  include skype
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

  $emacs = "${projects}/emacs-d"

  repository { $emacs:
    source  => 'bradleywright/emacs-d',
    require => File[$projects]
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

  file { "${home}/.local_zshrc":
    mode    => '0644',
    content => 'cdpath=(~/Projects ~)',
  }

  case $hostname {
    'kernel': {
      # Home machine
      include caffeine
      include skype

      file { "${home}/.local_zshrc":
        mode    => '0644',
        content => 'cdpath=(~/Projects ~)',
      }

      file { "${home}/.localgitconfig":
        mode    => '0644',
        content => "[user]
    email = brad@intranation.com
[credential]
    helper = osxkeychain",
      }
    }
    /^GDS.*$/: {
      # GDS machine
      package {
        [
         'parallel'
         ]:
      }
      # Work email is Gmail
      include mailplane::beta

      file { "${home}/.local_zshrc":
        mode    => '0644',
        content => 'cdpath=(~/Work ~/Projects ~)',
      }

      file { "${home}/.localgitconfig":
        mode    => '0644',
        content => '[user]
    email = bradley.wright@digital.cabinet-office.gov.uk
[credential]
    helper = osxkeychain',
      }
    }
  }
}
