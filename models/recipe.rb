# Creates a new recipe, which holds name, id...
# and an array of class Ingredient
Class Recipe
  attr_reader :id, :name, :description, :instructions, :ingredients

  def initialize(hash)
    @id = hash['id']
    @name = hash['name']
    @description = get_description(hash)
    @instructions = get_instructions(hash)
    @ingredients = get_ingredients(@id)
  end

  def get_description(hash)
    if hash['description'] == nil
      "This recipe doesn't have a description."
    else
      hash['description']
    end
  end

  def get_instructions(hash)
    if hash['instructions'] == nil
      "This recipe doesn't have any instructions."
    else
      hash['instructions']
    end
  end

  def self.all
    query = 'SELECT * FROM recipes'

    results = db_connection do |conn|
            conn.exec(query)
    end
    all_recipes = []

    results.each do |result|
      all_recipes << Recipe.new(result)
    end
    all_recipes
  end

  def self.find(id)
    query = "SELECT * FROM recipes WHERE recipes.id = $1"

    finders = db_connection do |conn|
            conn.exec_params(query, [id])
    end
    recipe = []

    finders.each do |data|
      recipe << Recipe.new(data)
    end
    recipe.first
  end

  def get_ingredients(recipe_id)
    query = 'SELECT * FROM ingredients WHERE ingredients.recipe_id = $1'
    results = db_connection do |conn|
        conn.exec_params(query, [recipe_id])
    end
    some_ingredients_for_a_recipe = []

    results.each do |result|
      some_ingredients_for_a_recipe << Ingredient.new(result)
    end
    some_ingredients_for_a_recipe
  end
end




