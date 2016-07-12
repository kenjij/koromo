require 'sequel'


module Koromo

  def self.sql
    SQL.shared_instance
  end

  class SQL

    def self.shared_instance
      @sql ||= SQL.new
    end

    def setup(conf)
      @config = conf
      # Sequel connection setup
      # Sequel.application_timezone = :local
      # Sequel.database_timezone = :utc
      Sequel::Model.db = Sequel.connect({adapter: 'tinytds'}.merge(config[:mssql]))
    end

    def config
      @config
    end

    def config_for_resource(name)
      name = name.to_sym
      c = config[:resources][name]
      c[:limit] ||= 10
      c
    end

    # Get model classes
    def model_for_resource(name)
      name = name.to_sym
      @models ||= {}
      return nil unless rc = config_for_resource(name)
      if @models[name].nil?
        m = Class.new(Sequel::Model)
        m.set_dataset(rc[:table])
        @models[name] = m
      end
      @models[name]
    end

    def get_resource(name, **args)
      return nil unless model = model_for_resource(name)
      p args[:params]
      conf = config_for_resource(name)
      set = model.select(*conf[:columns])
      if args[:id]
        array = set.where(conf[:key] => args[:id]).all
      else
        if args[:params]
          p_limit = args[:params][:limit]
          p_limit = p_limit.to_i if p_limit.class == String
          p_order = args[:params][:order]
          p_desc = true if args[:params][:desc]
          p_desc = false if args[:params][:asc]
        end
        p_limit ||= conf[:limit]
        p_order ||= conf[:order]
        p_desc ||= conf[:desc]
        set = set.limit(p_limit)
        set = (p_desc ? set.reverse_order(p_order) : set.order(p_order))
        p set.sql
        array = set.all
      end
      return nil if array.empty?
      case conf[:get][:class]
      when 'Hash'
        result = {}
        key = conf[:key]
        val = conf[:get][:value]
        array.each do |r|
          rec = r.values
          result.store(rec.delete(key), val ? rec[val] : rec)
        end
      when 'Array'
        result = array.map{ |r| r.values }
      end
      return result[0] if args[:id] && result.class == Array
      result
    end

  end

end
