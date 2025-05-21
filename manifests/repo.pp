# Class that manages the erlang repo
class erlang::repo {
  case $facts['os']['family'] {
    'RedHat': {
      contain erlang::repo::yum
    }
    'Debian': {}
    default: {
      fail("The only supported OS families are 'Debian' and 'RedHat', currently trying to install on OS family: ${$facts['os']['family']}")
    }
  }
}
