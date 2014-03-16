require 'merit/rule'
require 'merit/rules_badge_methods'
require 'merit/rules_points_methods'
require 'merit/rules_matcher'
require 'merit/controller_extensions'
require 'merit/model_additions'
require 'merit/judge'
require 'merit/reputation_change_observer'
require 'merit/sash_finder'
require 'merit/base_target_finder'
require 'merit/target_finder'
require 'merit/models/base/sash'
require 'merit/models/base/badges_sash'

module Merit
  def self.setup
    @config ||= Configuration.new
    yield @config if block_given?
  end

  # # Define ORM
  def self.orm
    @config.orm || :mongoid
  end

  # Define user_model_name
  def self.user_model
    @config.user_model_name.constantize
  end

  # Define current_user_method
  def self.current_user_method
    @config.current_user_method || "current_#{@config.user_model_name.downcase}".to_sym
  end

  def self.observers
    @config.observers
  end

  # @param class_name [String] The string version of observer class
  def self.add_observer(class_name)
    @config.add_observer(class_name)
  end

  class Configuration
    attr_accessor :orm, :user_model_name, :observers,
                  :current_user_method

    def initialize
      @orm = :mongoid
      @user_model_name = 'User'
      @observers = []
    end

    def add_observer(class_name)
      @observers << class_name
    end
  end

  setup
  add_observer('Merit::ReputationChangeObserver')

  class BadgeNotFound < Exception; end

  class Engine < Rails::Engine
    config.app_generators.orm Merit.orm

    initializer 'merit.controller' do |app|
      extend_orm_with_has_merit
      require_models
    end

    def require_models
      require 'merit/models/base/sash'
      require 'merit/models/base/badges_sash'
      require "merit/models/#{Merit.orm}/merit/badges_sash"
      require "merit/models/#{Merit.orm}/merit/sash"
      require "merit/models/#{Merit.orm}/merit/score"
    end

    def extend_orm_with_has_merit
      if Object.const_defined?('Mongoid')
        Mongoid::Document.send :include, Merit
      end
    end
  end
end
