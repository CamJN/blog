require 'test_helper'

class AbilityTest < ActiveSupport::TestCase

  User.all.each do |user|
    ActiveRecord::Base.descendants.select{|m| (m.name =~ /ActiveRecord::/).nil?}.each do |model|
      [:create, :read, :update, :destroy].each do |symbol|
        negative = user.role.name.capitalize + ' cannot ' + symbol.to_s + ' ' + model.name.pluralize
        positive = user.role.name.capitalize + ' can '    + symbol.to_s + ' ' + model.name.pluralize
        if (user.role.name == 'admin') or
          ((symbol.to_s == 'read') and (['Article','Comment'].include? model.name) and (not 'banned' == user.role.name)) or
          ((symbol.to_s == 'create') and ('Comment' == model.name) and (['moderator','registered'].include? user.role.name)) or
          ((['destroy','update'].include? symbol.to_s) and ('Comment' == model.name) and (['moderator','registered'].include? user.role.name))
          test positive do
            ability = Ability.new(user)
            assert ability.can?(symbol, model), negative
          end
        else
          test negative do
            ability = Ability.new(user)
            assert ability.cannot?(symbol, model), positive
          end
        end
      end
    end
  end

  User.all.each do |user|
    [:update, :destroy].each do |symbol|
      Comment.all.each do |comment|
        own = (comment.user_id == user.id)
        name = user.username.capitalize
        cname = comment.user.username.capitalize
        negative = name + ' cannot ' + symbol.to_s + ' ' + (own ? 'own' : cname.possessive) + ' Comment'
        positive = name + ' can '    + symbol.to_s + ' ' + (own ? 'own' : cname.possessive) + ' Comment'
        if ((not own) and
          (not ['moderator','admin'].include? user.role.name)) or
          (user.role.name == 'banned')
          test negative do
            ability = Ability.new(user)
            assert ability.cannot?(symbol, comment), positive
          end
        else
          test positive do
            ability = Ability.new(user)
            assert ability.can?(symbol, comment), negative
          end
        end
      end
    end
  end

end
