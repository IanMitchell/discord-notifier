require 'test_helper'
require 'date'

class Discord::EmbedTest < Minitest::Test
  def test_that_it_has_a_data_hash
    embed = Discord::Embed.new
    assert embed.data.is_a? Hash
  end

  def test_embed_fields_exist
    embed = Discord::Embed.new
    fields = %w(title description url timestamp color footer image thumbnail
                video provider author)

    fields.each do |field|
      assert embed.public_methods.include?(field.to_sym), "#{field} not found"
    end

    assert embed.public_methods.include? :add_field
    assert embed.public_methods.include? :field
  end

  def test_multiple_fields
    embed = Discord::Embed.new do
      add_field name: "Field 1"
      add_field name: "Field 2"
      add_field name: "Field 3"
    end

    assert_equal embed.data[:fields].size, 3
  end

  def test_embed_field_argument_types
    embed = Discord::Embed.new

    assert_raises(ArgumentError) { embed.title({ value: 'Hash' }) }
    embed.title 'String Value'

    assert_raises(ArgumentError) { embed.description({ value: 'Hash' }) }
    embed.description 'String Value'

    assert_raises(ArgumentError) { embed.url({ value: 'Hash' }) }
    embed.url 'String Value'

    assert_raises(ArgumentError) { embed.thumbnail('String Value') }
    embed.thumbnail value: 'Hash Value'

    assert_raises(ArgumentError) { embed.video('String Value') }
    embed.video value: 'Hash Value'

    assert_raises(ArgumentError) { embed.image('String Value') }
    embed.image value: 'Hash Value'

    assert_raises(ArgumentError) { embed.provider('String Value') }
    embed.provider value: 'Hash Value'

    assert_raises(ArgumentError) { embed.author('String Value') }
    embed.author value: 'Hash Value'

    assert_raises(ArgumentError) { embed.footer('String Value') }
    embed.footer value: 'Hash Value'

    assert_raises(ArgumentError) { embed.field('String Value') }
    embed.field value: 'Hash Value'

    assert_raises(ArgumentError) { embed.color({ hex: 'value' }) }
    assert_raises(ArgumentError) { embed.color(16_777_500) }
    embed.color 0x008000
    val = embed.data[:color]
    embed.color '#008000'
    assert_equal val, embed.data[:color]

    assert_raises(ArgumentError) { embed.timestamp({ value: 'Hash' }) }
    embed.timestamp DateTime.new(2001,2,3,4,5,6)
  end
end
