# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

def github(name, version, options = nil)
  options ||= {}
  options[:repo] ||= "boxen/puppet-#{name}"
  mod name, version, :github_tarball => options[:repo]
end

# Core modules for a basic development environment. You can replace
# some/most of those if you want, but it's not recommended.

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen", "3.0.1"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "dnsmasq",  "1.0.0"
github "gcc",      "2.0.1"
github "git",      "1.2.5"
github "homebrew", "1.4.1"
github "hub",      "1.0.3"
github "inifile",  "0.9.0", :repo => "cprice-puppet/puppetlabs-inifile"
github "nginx",    "1.4.2"
github "nodejs",   "1.0.0"
github "nvm",      "1.0.0"
github "ruby",     "6.3.0"
github "repository", "2.2.0"
github "stdlib",   "3.0.0", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",     "1.0.0"

# Optional/custom modules. There are tons available at
# https://github.com/boxen.

github "adium",    "1.1.0", :repo => "dieterdemeyer/puppet-adium"
github "alfred",   "1.0.2"
github "caffeine", "1.0.0"
github "chrome",   "1.1.1"
github "dropbox",  "1.1.0"
github "emacs",    "1.1.4", :repo => "bradleywright/puppet-emacs"
github "emacs-keybindings",    "1.0.0", :repo => "bradleywright/puppet-emacs-keybindings"
github "flux",     "0.0.1"
github "iterm2",   "1.0.2"
github "osx",      "1.3.0"
github "skype",    "1.0.2"
github "slate",    "1.0.1", :repo => "fromonesrc/puppet-slate"
github "vagrant",  "2.0.7"
github "zsh",      "1.0.0"
