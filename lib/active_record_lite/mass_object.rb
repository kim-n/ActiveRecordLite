class Class
  def my_attr_accessor(*args)
    args.each do |arg|
      self.send(:define_method, arg){ self.instance_variable_get("@#{arg.to_s}".to_sym) }
      self.send(:define_method, "#{arg.to_s}="){ |other| self.instance_variable_set("@#{arg.to_s}".to_sym, other) }
    end
  end
end

class MassObject
  # takes a list of attributes.
  # creates getters and setters.
  # adds attributes to whitelist.
  def self.my_attr_accessible(*attributes)
    my_attr_accessor(*attributes)
    @attributes = []
    attributes.each do |attribute|
      @attributes << attribute
    end
    @attributes
  end

  # returns list of attributes that have been whitelisted.
  def self.attributes
    @attributes
  end

  # takes an array of hashes.
  # returns array of objects.
  def self.parse_all(results)
    results.map do |hash_params|
      self.new(hash_params)
    end
  end

  # takes a hash of { attr_name => attr_val }.
  # checks the whitelist.
  # if the key (attr_name) is in the whitelist, the value (attr_val)
  # is assigned to the instance variable.
  def initialize(params = {})
    params.each do |attr_name, value|
      if self.class.attributes.include?(attr_name.to_sym)
        self.send("#{attr_name.to_s}=",  value)
      else
        raise "mass assignment to unregistered attribute #{attr_name}"
      end
    end
  end
end