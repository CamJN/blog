# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.renderer = SimpleNavigation::Renderer::Bootstrap

  navigation.items do |primary|
    primary.item :articles, 'Blog', articles_path do |sub_nav|
      Article.all.each do |a|
        sub_nav.item a.title.parameterize.underscore.to_sym, a.title, article_path(a)
      end
    end
    primary.dom_class = "nav navbar-nav"
  end
end
