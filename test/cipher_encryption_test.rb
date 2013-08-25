require 'test_helper'

class CipherTest < MiniTest::Unit::TestCase

  def test_aes_128_ctr_encrypt
    cipher = PolarSSL::Cipher.new("AES-128-CTR")

    cipher.setkey("1234567890123456", 128, PolarSSL::Cipher::OPERATION_ENCRYPT)
    cipher.update("hallo")
    encrypted = cipher.finish

    assert_not_nil encrypted
  end

end