require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade, :id

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
=begin
This class method creates the students table with columns that match the attributes of our individual students: an id (which is the primary key), the name and the grade.
=end 
    sql = <<-SQL 
      CREATE TABLE students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
=begin
This class method should be responsible for dropping the students table.
=end 
sql = <<-SQL 
      DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)

  end
=begin

=end 
  def save 
=begin
This instance method inserts a new row into the database using the attributes of the given object. This method also assigns the id attribute of the object once the row has been inserted into the database.
=end 
    if self.id 
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade) VALUES(?,?)
      SQL
      DB[:conn].execute(sql, name, grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
=begin
This method creates a student with two attributes, name and grade, and saves it into the students table.
=end 
    student = self.new(name, grade)
    student.save
  end

  def self.new_from_db(row)
=begin
This class method takes an argument of an array. When we call this method we will pass it the array that is the row returned from the database by the execution of a SQL query. We can anticipate that this array will contain three elements in this order: the id, name and grade of a student.
=end 
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(id, name, grade)
  end

  def self.find_by_name(name)
=begin
his class method takes in an argument of a name. It queries the database table for a record that has a name of the name passed in as an argument. Then it uses the #new_from_db method to instantiate a Student object with the database row that the SQL query returns.
=end 
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def update
=begin
This method updates the database row mapped to the given Student instance.
=end 
    sql = <<-SQL
    UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
