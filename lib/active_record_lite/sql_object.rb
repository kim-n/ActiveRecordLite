require_relative './associatable'
require_relative './db_connection' # use DBConnection.execute freely here.
require_relative './mass_object'
require_relative './searchable'
require 'active_support/inflector'

class SQLObject < MassObject
  # sets the table_name
  def self.set_table_name(table_name)
    @table_name = table_name
  end

  # gets the table_name
  def self.table_name
    @table_name #.underscore.pluralize
  end

  # querys database for all records for this type. (result is array of hashes)
  # converts resulting array of hashes to an array of objects by calling ::new
  # for each row in the result. (might want to call #to_sym on keys)
  def self.all
    results = DBConnection.execute(<<-SQL )
      SELECT * FROM #{@table_name.pluralize}
    SQL

    parse_all(results)

  end

  # querys database for record of this type with id passed.
  # returns either a single object or nil.
  def self.find(id)
    results = DBConnection.execute(<<-SQL, id)
      SELECT * FROM #{@table_name.pluralize} WHERE #{@table_name.pluralize}.id = ?
    SQL
    parse_all(results).first

  end

  # executes query that creates record in db with objects attribute values.
  # use send and map to get instance values.
  # after, update the id attribute with the helper method from db_connection
  def create

    attribute_symbols = self.class.attributes

    instance_varabiable_values = []
    attribute_symbols.each do |instance_var|
      instance_varabiable_values += self.send(instance_var)
    end
      #
    # question_marks = []
    # instance_varabiable_values.count.times {}

    DBConnection.execute(<<-SQL, instance_varabiable_values)
    INSERT INTO #{@table_name.pluralize} VALUES



    SQL


  end

  # executes query that updates the row in the db corresponding to this instance
  # of the class. use "#{attr_name} = ?" and join with ', ' for set string.
  def update

  end

  # call either create or update depending if id is nil.
  def save
  end

  # helper method to return values of the attributes.
  def attribute_values
  end
end
