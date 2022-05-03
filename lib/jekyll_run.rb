# frozen_string_literal: true

require "jekyll_plugin_logger"
require "liquid"
require_relative "jekyll_run/version"

# This implements a Jekyll tag plugin that executes a program and returns the output from STDOUT.
# Because the output includes the command that was executed,
# and is contains unselectable span tags,
# this plugin is intended to be embedded within a [jekyll_pre plugin tag](https://github.com/mslinn/jekyll_pre).
# Executes a program and returns the output from STDOUT.
class RunTag < Liquid::Tag
  # @param tag_name [String] is the name of the tag, which we already know.
  # @param command_line [Hash, String, Liquid::Tag::Parser] the arguments from the web page.
  # @param _parse_context [Liquid::ParseContext] hash that stores Liquid options.
  #        By default it has two keys: :locale and :line_numbers, the first is a Liquid::I18n object, and the second,
  #        a boolean parameter that determines if error messages should display the line number the error occurred.
  #        This argument is used mostly to display localized error messages on Liquid built-in Tags and Filters.
  #        See https://github.com/Shopify/liquid/wiki/Liquid-for-Programmers#create-your-own-tags
  # @return [void]
  def initialize(tag_name, command_line, parse_context)
    super
    @command = command_line
    @command = "" if @command.nil? || @command.empty?
    @logger = PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)
  end

  # Method prescribed by the Jekyll plugin lifecycle.
  # @param _liquid_context [Liquid::Context]
  # @return [String]
  def render(_liquid_context)
    @logger.debug "Running #{@command}"
    output = `#{@command}`.rstrip
    "<span class='unselectable'>$ </span>#{@command}\n<span class='unselectable'>#{output}</span>"
  end
end

PluginMetaLogger.instance.info { "Loaded jekyll_run v#{JekyllRunVersion::VERSION} plugin." }
Liquid::Template.register_tag("run", RunTag)
