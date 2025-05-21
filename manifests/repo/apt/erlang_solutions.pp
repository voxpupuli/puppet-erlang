# erlang erlang_solutions apt repo
class erlang::repo::apt::erlang_solutions (
  String $ensure = $erlang::repo::apt::ensure,
  String $location    = 'https://packages.erlang-solutions.com/debian',
  # trusty, xenial, bionic, etc
  String $release     = downcase($facts['os']['distro']['codename']),
  String $repos       = 'contrib',
  String $key         = 'A476FFB0288ADC13FE8B91A7708D410964E7272E',
  String $key_source  = 'https://binaries2.erlang-solutions.com/GPG-KEY-pmanager.asc',
  Optional[Variant[Numeric, String]] $pin = $erlang::package_apt_pin,
) inherits erlang {
  apt::source { 'erlang-erlang_solutions':
    ensure   => $ensure,
    location => $location,
    release  => $release,
    repos    => $repos,
    key      => {
      'id'     => $key,
      'source' => $key_source,
    },
  }

  if $pin {
    apt::pin { 'erlang':
      packages => '*',
      priority => $pin,
      origin   => inline_template('<%= require \'uri\'; URI(@location).host %>'),
    }
  }
}
