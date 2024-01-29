{
  config,
  pkgs,
  ...
}: {
  # Module that automatically enable cadvisor and feed the data into influxdb database.
  # Note that the influxdb database needs to be created by hand (cadvisor doesn't do it).
  # Grafana is also enabled, and need to be configured within the web interface at localhost:3000:
  time.timeZone = "Europe/Paris";
  services.cadvisor = {
    enable = false;
    listenAddress = "${config.networking.hostName}";
    storageDriver = "influxdb";
    storageDriverHost = "${config.networking.hostName}:8086";
    storageDriverDb = "cadvisor";
    extraOptions = [
      # https://github.com/google/cadvisor/blob/master/docs/runtime_options.md
      "--allow_dynamic_housekeeping=false"
    ];
  };

  services.influxdb = {
    enable = false;
  };

  services.grafana = {
    enable = false;
  };
}
