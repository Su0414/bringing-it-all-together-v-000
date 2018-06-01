class Dog
  attr_accessor :name, :breed, :id

  @@params = {:name => "",
              :breed => "",
              :id => nil
            }

  def initialize(params)
    @name = params[:name]
    @breed = params[:breed]
    @id = params[:id]
  end

  def self.create_table
    sql = <<-SQL
                CREATE TABLE IF NOT EXISTS dogs (
                  id INTEGER PRIMARY KEY,
                  name TEXT,
                  breed TEXT
                  )
            SQL
            DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
                DROP TABLE IF EXISTS dogs
            SQL
            DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
                  INSERT INTO dogs (name, breed)
                  VALUES (?,?)
              SQL
              DB[:conn].execute(sql, self.name, self.breed)
              @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end

  end

  def self.create(name:, breed:)
    @@params[:name] = name
    @@params[:breed] = breed
    new_dog = Dog.new(@@params)
    new_dog.save
    new_dog
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM dogs WHERE id = ?"
    result = DB[:conn].execute(sql, id)[0]
    Dog.new(result[0], result[1], result[2])
  end

  def self.find_or_create_by(name:, breed:)
    new_dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
    if !new_dog.empty?
      new_dog_data = new_dog[0]
      new_dog = Dog.new(new_dog_data[0], new_dog_data[1], new_dog_data[2])
    else
      new_dog = self.create(name: name ,breed: breed)
    end
    new_dog
    end

  def self.new_from_db

  end

  def find_by_name
  end

  def update
  end

end
