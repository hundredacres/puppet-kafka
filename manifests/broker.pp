# == Class: kafka::broker
#
# This class will install kafka with the broker role.
#
# === Requirements/Dependencies
#
# Currently reequires the puppetlabs/stdlib module on the Puppet Forge in
# order to validate much of the the provided configuration.
#
# === Parameters
#
# [*version*]
# The version of kafka that should be installed.
#
# [*scala_version*]
# The scala version what kafka was built with.
#
# [*install_dir*]
# The directory to install kafka to.
#
# [*mirror_url*]
# The url where the kafka is downloaded from.
#
# [*config*]
# A hash of the configuration options.
#
# [*install_java*]
# Install java if it's not already installed.
#
# === Examples
#
# Create a single broker instance which talks to a local zookeeper instance.
#
# class { 'kafka::broker':
#  config => { 'broker.id' => '0', 'zookeeper.connect' => 'localhost:2181' }
# }
class kafka::broker (
  $version = $kafka::params::version,
  $scala_version = $kafka::params::scala_version,
  $install_dir = $kafka::params::install_dir,
  $mirror_url = $kafka::params::mirror_url,
  $config = $kafka::params::broker_config_defaults,
  $install_java = $kafka::params::install_java
) inherits kafka::params {

  validate_re($::osfamily, 'RedHat|Debian\b', "${::operatingsystem} not supported")
  validate_re($version, '\d+\.\d+\.\d+\.*\d*', "${version} does not match semver")
  validate_re($scala_version, '\d+\.\d+\.\d+\.*\d*', "${version} does not match semver")
  validate_re($install_dir, '([^\0 ]\|\\ )*', "${install_dir} is not a valid install path")
  validate_re($mirror_url, '^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$', "${mirror_url} is not a valid url")
  validate_hash($config)
  validate_bool($install_java)

  class { 'kafka::broker::install': } ->
  class { 'kafka::broker::config': } ~>
  class { 'kafka::broker::service': } ->
  Class['kafka::broker']
}
