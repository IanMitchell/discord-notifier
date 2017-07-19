require 'test_helper'

class Discord::FormDataTest < Minitest::Test
  def expected_form_body
    Dir.chdir(File.dirname(__FILE__))
    File.read('../../form_body.txt')
  end

  def test_that_boundary_is_defined
    refute_nil Discord::BOUNDARY
  end

  def test_form_data_request_has_correct_header
    params = {
      url: 'http://test.com',
      username: 'Gem Test',
      avatar_url: 'http://avatar.com/discord.png',
      file: test_attachment
    }

    request = Discord.form_data_request(URI('http://test.com'), params)
    assert_equal 'multipart/form-data', request.content_type
  end

  def test_multipart_form_data_has_correct_format
    expected_body = expected_form_body
    params = {
      url: 'http://test.com',
      username: 'Gem Test',
      avatar_url: 'http://avatar.com/discord.png',
      file: test_attachment
    }

    body = Discord.multipart_form_data(params)
    assert_equal expected_body, body
  end
end
