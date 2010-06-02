module OpenID
  class CustomFetcher < StandardFetcher

    attr_accessor :ca_path

    def make_connection(uri)
      conn = make_http(uri)

      if !conn.is_a?(Net::HTTP)
        raise RuntimeError, sprintf("Expected Net::HTTP object from make_http; got %s",
                                    conn.class)
      end

      if uri.scheme == 'https'
        if supports_ssl?(conn)

          conn.use_ssl = true

          case
          when @ca_path
            set_verified(conn, true)
            conn.ca_path = @ca_path
          when @ca_file
            set_verified(conn, true)
            conn.ca_file = @ca_file
          else
            Util.log("WARNING: making https request to #{uri} without verifying " +
                     "server certificate; no CA path was specified.")
            set_verified(conn, false)
          end
        else
          raise RuntimeError, "SSL support not found; cannot fetch #{uri}"
        end
      end

      return conn
    end
  end
end
