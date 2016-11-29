class Factory

  def self.new(klass, *attrs, &block)
    Class.new do
      attrs.each{ |attr| send(:attr_accessor, attr) }

      define_method :initialize do |*params|
        raise 'missing argument' if params.count < attrs.count
        attrs.each_with_index{ |attr, i| instance_variable_set("@#{attr}", params[i]) }
      end

      define_method :[] do |key|
        raise 'unknown property' if key+1 > attrs.count
        instance_variable_get('@'+attrs[key]) if key.is_a? Integer
      end

      define_method :[]= do |key, value|
        raise 'unknown property' if key+1 > attrs.count
        instance_variable_set('@'+attrs[key], value) if key.is_a? Integer
      end

      define_method :length do
        attrs.count
      end

      alias_method 'size', 'length'

      class_eval(&block) if block_given?
    end
  end

end


reader = Factory.new('Reader', 'name', 'year')
book = Factory.new('Book', 'author', 'name')

mike = reader.new('mike', 1990)
p mike.name # 'mike'
p mike[1] # 1990
mike[1] = 1995
p mike[1] # 1995
p mike.length #2
p mike.size #2
p mike[2] # unknown property
book1 = book.new('author1') # missing argument
