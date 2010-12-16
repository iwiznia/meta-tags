module MetaTags
  # Contains methods to use in controllers.
  #
  # You can define several instance variables to set meta tags:
  #   @page_title = 'Member Login'
  #   @page_description = 'Member login page.'
  #   @page_keywords = 'Site, Login, Members'
  #
  # Also you can use {InstanceMethods#set_meta_tags} method, that have the same parameters
  # as {ViewHelper#set_meta_tags}.
  #
  module ControllerHelper
    def self.included(base)
      base.send :include, InstanceMethods
      base.alias_method_chain :render, :meta_tags
      #base.send :before_filter, :set_metas
    end

    module InstanceMethods
      # Processes the <tt>@page_title</tt>, <tt>@page_keywords</tt>, and
      # <tt>@page_description</tt> instance variables and calls +render+.
      def render_with_meta_tags(*args, &block)
        meta_tags = {}
        meta_tags[:title]       = @page_title       if @page_title
        meta_tags[:keywords]    = @page_keywords    if @page_keywords
        meta_tags[:description] = @page_description if @page_description
        set_meta_tags(meta_tags)

        render_without_meta_tags(*args, &block)
      end

      def set_meta_tags(meta_tags = {}, append = false)
        @meta_tags ||= {}
        if !append
          @meta_tags.merge!(meta_tags || {})
        else
          append_meta_tags(meta_tags)
        end
      end

      def append_meta_tags(meta_tags = {})
        die!
        @meta_tags ||= {}
        meta_tags.each do |tag, value|
          @meta_tags[tag] ||= []

          @meta_tags[tag] = [@meta_tags[tag]] if(@meta_tags[tag].is_a?(String))
          @meta_tags[tag] += [*value]
        end
      end

      def set_meta_vars(vars = {}, append = true)
        @meta_vars ||= {}
        if append
          @meta_vars.merge!(vars)
        else
          @meta_vars = vars
        end
      end

      protected :set_meta_tags
    end
  end
end
