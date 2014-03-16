require 'merit/model_additions'
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
    :mongoid
  end

  # Define user_model_name
  def self.user_model
    @config.user_model_name.constantize
  end

  # Define current_user_method
  def self.current_user_method
    @config.current_user_method || "current_#{@config.user_model_name.downcase}".to_sym
  end

  class Configuration
    attr_accessor :orm, :user_model_name, :current_user_method

    def initialize
      @orm = :mongoid
      @user_model_name = 'User'
    end
  end

  setup

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
      require 'merit/models/mongoid/merit/badges_sash'
      require 'merit/models/mongoid/merit/sash'
      require 'merit/models/mongoid/merit/score'
    end

    def extend_orm_with_has_merit
      Mongoid::Document.send :include, Merit
    end
  end
end
