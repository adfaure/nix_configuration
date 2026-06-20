{lib, ...}: hostname: tag: let
  host = lib.hosts.${hostname} or null;
in
  host != null && lib.elem tag (host.tags or [])
