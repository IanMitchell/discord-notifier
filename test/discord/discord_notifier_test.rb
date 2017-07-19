require 'test_helper'
require 'net/http'
require 'json'

class Discord::NotifierTest < Minitest::Test
  def setup
    Discord::Notifier.setup do |config|
      config.url = 'http://test.com'
      config.username = 'Gem Test'
      config.avatar_url = 'http://avatar.com/discord.png'
    end
  end

  def teardown
    Discord::Notifier.setup do |config|
      config.url = nil
      config.username = nil
      config.avatar_url = nil
      config.wait = nil
    end
  end

  def test_configuration
    expected_config = Discord::Config.new 'http://test.com',
                                          'Gem Test',
                                          'http://avatar.com/discord.png',
                                          nil

    Discord::Notifier.setup do |config|
      assert_equal expected_config, config
    end
  end

  def test_has_message
    assert Discord::Notifier.methods.include? :message
  end

  def test_message_responds_to_correct_format
    form_params = nil
    request_params = nil
    file = test_attachment

    Discord::Notifier.stub :send_form, ->(args) { form_params = args } do
      Discord::Notifier.message file
    end

    assert form_params

    Discord::Notifier.stub :send_request, ->(args) { request_params = args } do
      Discord::Notifier.message "String Message"
    end

    assert request_params
  end

  def test_string_message
    actual_params = nil
    expected_params = {
      url: 'http://test.com',
      username: 'Gem Test',
      avatar_url: 'http://avatar.com/discord.png',
      content: 'String Message'
    }

    actual_params = Discord::Notifier.payload "String Message", {}
    assert_equal expected_params, actual_params
  end

  def test_embed_message
    actual_params = nil
    expected_params = {
      url: 'http://test.com',
      username: 'Gem Test',
      avatar_url: 'http://avatar.com/discord.png',
      embeds: [{
        title: 'Embed Message Test',
        description: 'Sending an embed through Discord Notifier',
        url: 'http://github.com/ianmitchell/discord_notifier',
        color: 0x008000,
        thumbnail: {
          url: 'http://avatar.com/discord.png'
        },
        author: {
          name: 'Ian Mitchell',
          url: 'http://ianmitchell.io'
        },
        footer: {
          text: 'Mini MiniTest Test'
        },
        fields: [
          {
            name: 'Content',
            value: 'This is a content section'
          },
          {
            name: 'Subsection',
            value: 'This is a content subsection'
          }
        ]
      }]
    }

    embed = Discord::Embed.new do
      title 'Embed Message Test'
      description 'Sending an embed through Discord Notifier'
      url 'http://github.com/ianmitchell/discord_notifier'
      color 0x008000
      thumbnail url: 'http://avatar.com/discord.png'
      author name: 'Ian Mitchell',
             url: 'http://ianmitchell.io'
      footer text: 'Mini MiniTest Test'
      add_field name: 'Content', value: 'This is a content section'
      add_field name: 'Subsection', value: 'This is a content subsection'
    end

    actual_params = Discord::Notifier.payload embed, {}
    assert_equal expected_params, actual_params
  end

  def test_custom_config_message
    custom_config = {
      url: 'http://custom.com',
      username: 'Gem Config Test',
      avatar_url: 'http://avatar.com/slack.png',
      wait: true
    }
    actual_params = nil
    expected_params = {
      content: 'String Message'
    }.merge(custom_config)

    actual_params = Discord::Notifier.payload "String Message", custom_config
    assert_equal expected_params, actual_params
  end

  def test_multiple_embeds
    actual_params = nil
    expected_params = {
      url: 'http://test.com',
      username: 'Gem Test',
      avatar_url: 'http://avatar.com/discord.png',
      embeds: [
        {
          title: 'Embed Message Test',
          description: 'Sending an embed through Discord Notifier',
          url: 'http://github.com/ianmitchell/discord_notifier',
        },
        {
          title: 'Second Embed Message Test',
          description: 'Sending an embed through Discord Notifier',
          url: 'http://github.com/ianmitchell/discord_notifier',
        }
      ]
    }

    embed_one = Discord::Embed.new do
      title 'Embed Message Test'
      description 'Sending an embed through Discord Notifier'
      url 'http://github.com/ianmitchell/discord_notifier'
    end

    embed_two = Discord::Embed.new do
      title 'Second Embed Message Test'
      description 'Sending an embed through Discord Notifier'
      url 'http://github.com/ianmitchell/discord_notifier'
    end

    actual_params = Discord::Notifier.payload [embed_one, embed_two], {}
    assert_equal expected_params, actual_params
  end

  def test_file_attachment
    file = test_attachment
    actual_params = nil
    expected_params = {
      url: 'http://test.com',
      username: 'Gem Test',
      avatar_url: 'http://avatar.com/discord.png',
      file: file
    }

    actual_params = Discord::Notifier.payload file, {}
    assert_equal expected_params, actual_params
  end

  def test_incorrect_message_type
    assert_raises ArgumentError do
      Discord::Notifier.message 42
    end
  end

  def test_endpoint
    endpoint = Discord::Notifier.endpoint url: 'http://test.com'
    assert endpoint.eql? URI('http://test.com')

    endpoint = Discord::Notifier.endpoint url: 'http://test.com', wait: true
    assert endpoint.eql? URI('http://test.com?wait=true')
  end
end
