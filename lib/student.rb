class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  

  attr_accessor :name, :grade
  attr_reader :id

  @@all = []

  def self.all
    @@all
  end

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id

    @@all << self
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    sql = <<-SQL
      SELECT * from students 
    SQL
    @id = DB[:conn].execute(sql)[0][0]
    #I had to add the double zeros becuase the return value is an array of arrays. I'm kind of curious why. Need to investigate a bit more.
  end

  def self.create
    student = Student.new(name, grade)
    student.save
    student
  end
  
end
