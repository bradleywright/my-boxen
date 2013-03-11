# Public: Install Emacs.app into /Applications.
#
# Examples
#
#   include emacs

class emacs {
  package { 'Emacs':
    provider => 'appdmg',
    source   => 'http://emacsformacosx.com/emacs-builds/Emacs-24.3-universal-10.6.8.dmg'
  }
}
