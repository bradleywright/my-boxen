# Removes Spotlight search
class remove_spotlight {
  exec { 'mv-spotlight':
    command => 'sudo mv -f /System/Library/CoreServices/Search.bundle /System/Library/CoreServices/Search.bundle.bak',
    notify  => Exec['killall SystemUIServer'],
    unless  => 'test ! -e /System/Library/CoreServices/Search.bundle';
  }

  exec { 'killall SystemUIServer':
    refreshonly => true;
  }
}
