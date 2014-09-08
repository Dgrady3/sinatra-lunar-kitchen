# called on by class Recipe, creates new ingredient
require 'pg'

Class Ingredient
  attr_reader :id, :name, :ingredient_id

  def initialize(hash)
    @id = hash['id']
    @name = hash['name']
    @ingredient_id = hash['ingredient_id']
  end

  def self.db_connection
    begin
      connection = PG.connect(dbname: 'recipes')

      yield(connection)

    ensure
      connection.close
    end
  end

  def self.all
    query = 'SELECT * FROM ingredients'

    results = db_connection do |conn|
            conn.exec(query)
    end
    all_ingredients = []

    results.each do |result|
      all_ingredients << Ingredient.new(result)
    end
    all_ingredients
  end
end

