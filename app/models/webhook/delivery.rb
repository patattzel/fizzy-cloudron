class Webhook::Delivery < ApplicationRecord
  USER_AGENT = "fizzy/1.0.0 Webhook"
  ENDPOINT_TIMEOUT = 7.seconds
  DNS_RESOLUTION_TIMEOUT = 2
  PRIVATE_IP_RANGES = [
    # Loopback
    IPAddr.new("127.0.0.0/8"),
    IPAddr.new("::1/128"),
    # IPv4 mapped to IPv6
    IPAddr.new("::ffff:0:0/96"),
    # RFC1918 - local network IP addresses
    IPAddr.new("10.0.0.0/8"),
    IPAddr.new("172.16.0.0/12"),
    IPAddr.new("192.168.0.0/16"),
    # Link-local (DHCP and router stuff)
    IPAddr.new("169.254.0.0/16"),
    IPAddr.new("fe80::/10"),
    # ULA
    IPAddr.new("fc00::/7")
  ].freeze

  belongs_to :webhook
  belongs_to :event

  store :request, coder: JSON
  store :response, coder: JSON

  encrypts :request, :response

  enum :state, %w[ pending in_progress completed errored ].index_by(&:itself), default: :pending

  def deliver_later
    Webhook::DeliveryJob.perform_later(self)
  end

  def deliver
    in_progress!

    self.request[:headers] = headers
    self.response = perform_request

    completed!
    save!
  rescue
    errored!
    raise
  end

  def succeeded?
    completed? && response[:error].blank? && response[:code].between?(200, 299)
  end

  private
    def perform_request
      if private_uri?
        { error: :private_uri }
      else
        response = http.request(
          Net::HTTP::Post.new(uri, headers).tap { |request| request.body = payload }
        )

      { code: response.code.to_i, headers: response.to_hash }
      end
    rescue Resolv::ResolvTimeout, Resolv::ResolvError, SocketError
      { error: :dns_lookup_failed }
    rescue Net::OpenTimeout, Net::ReadTimeout, Errno::ETIMEDOUT
      { error: :connection_timeout }
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ECONNRESET
      { error: :destination_unreachable }
    rescue OpenSSL::SSL::SSLError
      { error: :failed_tls }
    end

    def private_uri?
      ip_addresses = []

      Resolv::DNS.open(timeouts: DNS_RESOLUTION_TIMEOUT) do |dns|
      dns.each_address(uri.host) do |ip_address|
          ip_addresses << IPAddr.new(ip_address)
        end
      end

      ip_addresses.any? do |ip_address|
        PRIVATE_IP_RANGES.any? do |private_ip_range|
          private_ip_range.include?(ip_address)
        end
      end
    end

    def uri
      @uri ||= URI(webhook.url)
    end

    def http
      Net::HTTP.new(uri.host, uri.port).tap do |http|
        http.use_ssl = (uri.scheme == "https")
        http.open_timeout = ENDPOINT_TIMEOUT
        http.read_timeout = ENDPOINT_TIMEOUT
      end
    end

    def headers
      {
        "User-Agent" => USER_AGENT,
        "Content-Type" => "application/json",
        "X-Webhook-Signature" => signature,
        "X-Webhook-Timestamp" => Time.current.utc.iso8601
      }
    end

    def signature
      OpenSSL::HMAC.hexdigest("SHA256", webhook.signing_secret, payload)
    end

    def payload
      { test: :test }.to_json
    end
end
