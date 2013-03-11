# Public: Install Emacs.app into /Applications.
#
# Examples
#
#   include emacs::pretest

# Note this is the emacsformacosx.com pretest DMG
class emacs::pretest {
  package { 'Emacs':
    provider => 'appdmg',
    source   => 'http://emacsformacosx.com/emacs-builds/Emacs-pretest-24.3-rc3-universal-10.6.8.dmg'
  }
}
