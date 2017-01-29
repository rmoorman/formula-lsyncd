lsyncd:
  # Will template /etc/lsyncd/lsyncd.conf.lua
  # As the config syntax is to complex to write a readable template for,
  # this is taken as a string
  config: |
      sync {
          default.rsync,
          source    = "/var/www/",
          target    = "172.16.0.11:/var/www",
          delay     = 5,
          rsync     = {
              binary   = "/usr/bin/rsync",
              archive  = true,
              compress = true
          }
      }
      
      settings {
          statusInterval = 1,
          statusFile = "/var/log/lsyncd-status.log",
          insisit = true,
          nodaemon = false,
      }
