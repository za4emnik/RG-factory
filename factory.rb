class Factory

  def self.new(klass, *attrs, &block)
    Class.new do
      class_eval(&block) if block_given?
      attrs.each{ |attr| send(:attr_accessor, attr) }

      define_method :initialize do |*params|
        attrs.each_with_index{ |attr, i| instance_variable_set("@#{attr}", params[i]) }
      end

    end
  end

end


reader = Factory.new('Reader', 'name', 'year')
book = Factory.new('Book', 'author', 'name')
book1 = book.new('author1','book1')

p book1.name # 'book1'
p book1.name # 'author1'
