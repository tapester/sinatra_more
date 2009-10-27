require 'helper'
require 'fixtures/markup_app/app'

class TestTagHelpers < Test::Unit::TestCase
  def app
    MarkupDemo.tap { |app| app.set :environment, :test }
  end

  context 'for #tag method' do
    should("support tags with no content no attributes") do
      assert_has_tag(:br) { tag(:br) }
    end
    should("support tags with no content with attributes") do
      actual_html = tag(:br, :style => 'clear:both', :class => 'yellow') 
      assert_has_tag(:br, :class => 'yellow', :style=>'clear:both') { actual_html }
    end
    should "support tags with content no attributes" do
      assert_has_tag(:p, :content => "Demo String") { tag(:p, :content => "Demo String") }
    end
    should "support tags with content and attributes" do
      actual_html = tag(:p, :content => "Demo", :class => 'large', :id => 'intro')
      assert_has_tag('p#intro.large', :content => "Demo") { actual_html }
    end
  end

  context 'for #content_tag method' do
    should "support tags with content as parameter" do
      actual_html = content_tag(:p, "Demo", :class => 'large', :id => 'thing')
      assert_has_tag('p.large#thing', :content => "Demo") { actual_html }
    end
    should "support tags with content as block" do
      actual_html = content_tag(:p, :class => 'large', :id => 'star') { "Demo" }
      assert_has_tag('p.large#star', :content => "Demo") { actual_html }
    end
    should "support tags with erb" do
      visit '/erb/content_tag'
      assert_have_selector :p, :content => "Test 1", :class => 'test', :id => 'test1'
      assert_have_selector :p, :content => "Test 2"
      assert_have_selector :p, :content => "Test 3"
      assert_have_selector :p, :content => "Test 4"
    end
    should "support tags with haml" do
      visit '/haml/content_tag'
      assert_have_selector :p, :content => "Test 1", :class => 'test', :id => 'test1'
      assert_have_selector :p, :content => "Test 2"
      assert_have_selector :p, :content => "Test 3", :class => 'test', :id => 'test3'
      assert_have_selector :p, :content => "Test 4"
    end
  end

  context 'for #input_tag method' do
    should "support field with type" do
      assert_has_tag('input[type=text]') { input_tag(:text) }
    end
    should "support field with type and options" do
      actual_html = input_tag(:text, :class => "first", :id => 'texter')
      assert_has_tag('input.first#texter[type=text]') { actual_html }
    end
  end

end
