require_relative 'test_helper'
require 'socket'

class SSLConnectionTest < MiniTest::Unit::TestCase

  def test_simple_connection
    GC.stress = true
    socket = TCPSocket.new('polarssl.org', 443)

    GC.start

    entropy = PolarSSL::Entropy.new

    ctr_drbg = PolarSSL::CtrDrbg.new(entropy)

    ssl = PolarSSL::SSL.new

    ssl.set_endpoint(PolarSSL::SSL::SSL_IS_CLIENT)
    ssl.set_authmode(PolarSSL::SSL::SSL_VERIFY_NONE)
    ssl.set_rng(ctr_drbg)

    # # TODO: Implement passing methods/procs to people can define their own send/recv methods
    ssl.set_bio(Proc.new { |fp| }, socket, Proc.new { |fp| }, socket)

    ssl.handshake

    ssl.write("GET / HTTP/1.0\r\nHost: polarssl.org\r\n\r\n")

    while chunk = ssl.read(1024)
      puts chunk
    end

    puts "--- meh ---   "

    ssl.close_notify

    socket.close

    ssl.close
  end

end
