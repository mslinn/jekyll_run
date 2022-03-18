# frozen_string_literal: true

require "jekyll"
require_relative "jekyll_run/version"
require "jekyll_plugin_logger"

# Jekyll tag plugin that executes a program and returns the output from STDOUT.
# Because the output includes the command that was executed,
# and is contains unselectable span tags,
# this plugin is intended to be embedded within a pre tag.
module Jekyll
  # Executes a program and returns the output from STDOUT.
  class RunTag < Liquid::Tag
    # Constructor.
    # @param tag_name [String] is the name of the tag, which we already know.
    # @param command_line [Hash, String, Liquid::Tag::Parser] the arguments from the web page.
    # @param tokens [Liquid::ParseContext] tokenized command line
    # @return [void]
    def initialize(tag_name, command_line, tokens)
      super
      @command = command_line
      @command = "" if @command.nil? || @command.empty?
    end

    # Method prescribed by the Jekyll plugin lifecycle.
    # @return [String]
    def render(_context)
      info "Running #{@command}"
      output = `#{@command}`.rstrip
      "<span class='unselectable'>$ </span>#{@command}\n<span class='unselectable'>#{output}</span>"
    end
  end
end

Liquid::Template.register_tag("run", Jekyll::RunTag)
Jekyll.info "Loaded run plugin."
