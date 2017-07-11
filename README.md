# Discord::Notifier

A light wrapper around sending [Discord](https://discordapp.com) webhooks and embeds.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'discord-notifier'
```

And then execute:

    $ bundle

## Usage

#### Configuration

You can set defaults for Discord Notifier to use. For descriptions of what the fields do, refer to the [Discord webhook documentation](https://discordapp.com/developers/docs/resources/webhook#execute-webhook).

```ruby
Discord::Notifier.setup do |config|
  config.url = 'WEBHOOK_URL'
  config.username = 'My Webhook Username'
  config.avatar_url = ''

  # Defaults to `false`
  config.wait = true
end
```

If you're using Rails, place this in `config/initializers/discord_notifier.rb`.

#### Standard Message

To send a standard string message, use

```ruby
Discord::Notifier.message('Discord Notifier Webhook Notification')
```

#### Embeds

To create and send an embed, use

```ruby
embed = Discord::Embed.new do
  title "Discord Ruby Notification"
  add_author name: "Webhook Bot",
             avatar_url: 'AUTHOR_AVATAR'

  add_footer text: 'Notification via DiscordNotifier Gem',
             icon_url: 'ICON_URL'
end

Discord::Notifier.message(embed)
```

For a list of embed fields and parameters you can use, refer to the [official documentation](https://discordapp.com/developers/docs/resources/channel#embed-object). Please note that not all embed types and fields are supported through webhooks. You can [read more about the exceptions here](https://discordapp.com/developers/docs/resources/webhook#execute-webhook).

#### Attachments

Attachments aren't currently supported, but I hope to have them soon!

#### Overriding Configuration

If you want to override the default configuration, you can pass new values when sending a webhook notification.

```ruby
Discord::Notifier.message 'Custom URL and Avatar',
                          url: 'NEW_WEBHOOK_URL',
                          avatar_url: 'SECOND_AVATAR_URL'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
