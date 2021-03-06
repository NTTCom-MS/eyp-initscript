define initscript::service(
                            $cmd              = undef,
                            $cmd_start        = undef,
                            $cmd_stop         = undef,
                            $ensure           = 'present',
                            $run_user         = 'root',
                            $initscript       = $name,
                            $option_scripts   = [],
                            $description      = "default script for ${name}",
                            $tcp_listen_check = undef,
                            $pid_file         = "/var/run/generic.init.${name}.pid",
                            $debug            = undef,
                            $define_service   = false,
                            $service_enable   = true,
                            $service_ensure   = 'running',
                          ) {
  include ::initscript

  # validacions
  if($cmd==undef)
  {
    if($cmd_stop==undef or $cmd_start==undef)
    {
      fail("both cmd_start and cmd_stop must be defined cmd_start(${cmd_start}) / cmd_stop(${cmd_stop})")
    }
  }
  else
  {
    if($cmd_stop!=undef or $cmd_start!=undef)
    {
      fail("neither cmd_start nor cmd_stop can be defined if cmd(${cmd}) is defined - cmd_start(${cmd_start}) / cmd_stop(${cmd_stop})")
    }
  }

  file { "/etc/init.d/${initscript}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/initscript.erb"),
  }

  if $define_service and ($ensure != 'absent')
  {
    service { $initscript:
      ensure    => $service_ensure,
      enable    => $service_enable,
      subscribe => File["/etc/init.d/${initscript}"],
    }
  }
}
