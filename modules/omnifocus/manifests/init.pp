# Public: Install Omnifocus.app into /Applications.
#
# Examples
#
#   include omnifocus

## FIXME: this requires a licence accept, which doesn't work in
## Puppet.
## http://superuser.com/questions/221136/bypass-a-licence-agreement-when-mounting-a-dmg-on-the-command-line
class omnifocus {
  package { 'OmniFocus':
    provider => 'appdmg',
    source   => 'http://www.omnigroup.com/ftp1/pub/software/MacOSX/10.6/OmniFocus-1.10.4.dmg'
  }
}
