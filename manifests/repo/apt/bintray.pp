# erlang bintray apt repo
class erlang::repo::apt::bintray (
  String $ensure = $erlang::repo::apt::ensure,
  String $location    = 'https://dl.bintray.com/rabbitmq-erlang/debian',
  # trusty, xenial, bionic, etc
  String $release     = downcase($facts['os']['distro']['codename']),
  String $repos       = 'erlang',
  String $key         = '0A9AF2115F4687BD29803A206B73A36E6026DFCA',
  String $key_source  = 'https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc',
  Optional[Variant[Numeric, String]] $pin = $erlang::package_apt_pin,
) inherits erlang {
  apt::source { 'erlang-bintray':
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
