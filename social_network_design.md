# {{TABLE NAME}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

As a social network user,
So I can have my information registered,
I'd like to have a user account with my email address.

As a social network user,
So I can have my information registered,
I'd like to have a user account with my username.

As a social network user,
So I can write on my timeline,
I'd like to create posts associated with my user account.

As a social network user,
So I can write on my timeline,
I'd like each of my posts to have a title and a content.

As a social network user,
So I can know who reads my posts,
I'd like each of my posts to have a number of views.


```
# EXAMPLE

Table: accounts

Columns:
id | email | username

Table: posts

Columns: 
id | title | content | num of views

```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql

CREATE TABLE accounts( 
id SERIAL PRIMARY KEY,
email text,
username text
);
CREATE TABLE posts(
id SERIAL PRIMARY KEY,
title text,
content text,
num_of_views text,
account_id int,
constraint fk_account foreign key(account_id) references 
accounts(id)
);

INSERT INTO "public"."accounts" ("id", "email", "username") VALUES 
(1, 'test1@example.com', 'A'),
(2, 'test2@example.com', 'B'),
(3, 'test3@example.com', 'C'),
(4, 'test4@example.com', 'D');

INSERT INTO "public"."posts" ("id", "title", "content", "num_of_views") VALUES 
(1, 'A', 'some words1', '1'),
(2, 'B', 'some words2', '2'),
(3, 'C', 'some words3', '3'),
(4, 'D', 'some words4', '4');
```

```bash
createdb social_network
psql -h 127.0.0.1 social_network < seeds.sql
```

## 3. Define the class names


```ruby
class Account 
end 

class AccountRepository
end

class Post 
end

class PostRepository
end 

```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
class Account 
    attr_accessor :id, :email, :username 
end 

class Post 
    attr_accessor :id, :title, :content, :num_of_views, :account_id
end 


# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# student = Student.new
# student.name = 'Jo'
# student.name
```


## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby

class AccountRepository

    def all 
        sql = 'SELECT * FROM accounts;'
        result = DatabaseConnection.exec_params(sql, [])
        #Returns list of accounts
    end 

    def find(id)

    end 

    def create(account) 
        sql = 'INSERT INTO accounts (id, email, username) VALUES ($1, $2, $3);'
        params = [account.email, account.username]

        DatabaseConnection.exec_params(sql, params)

        return nil
    end

    def delete(id)
        sql = 'DELETE FROM accounts WHERE id = $1;'
        DatabaseConnect.exec_params(sql, [id])

        return nil
    end

    def update(id, col, val) 
        
        if col == 'email'
            sql = 'UPDATE accounts SET email = $2 WHERE id = $1;'
        elsif col == 'username'
            sql = 'UPDATE accounts SET username = $2 WHERE id = $1;'
        end 
        params = [id, val]
        DatabaseConnection.exec_params(sql, params)

        return nil
    end 
end 

class PostRepository
    def all 
        sql = 'SELECT * FROM posts;'
        result = DatabaseConnection.exec_params(sql, [])
        #Returns list of accounts
    end 

    def find(id)
    end 

    def create(post) 
        sql = 'INSERT INTO posts (id, title, content, num_of_view, account_id) VALUES ($1, $2, $3, $4, $5);'
        params = [post.title, post.content, post.num_of_view, post.account_id]

        DatabaseConnection.exec_params(sql, params)

        return nil
    end

    def delete(id)
        sql = 'DELETE FROM posts WHERE id = $1;'
        DatabaseConnect.exec_params(sql, [id])

        return nil
    end

    def update(id, col, val) 
        
        if col == 'title'
            sql = 'UPDATE posts SET title = $2 WHERE id = $1;'
        elsif col == 'content'
            sql = 'UPDATE posts SET content = $2 WHERE id = $1;'
        elsif col == 'num_of_view'
            sql = 'UPDATE posts SET num_of_view = $2 WHERE id = $1;'
        elsif col == 'account_id'
            sql = 'UPDATE posts SET account_id = $2 WHERE id = $1;'
        end 
        params = [id, val]
        DatabaseConnection.exec_params(sql, params)

        return nil
    end
end

```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all accounts
repo = AccountRepository.new
accounts = repo.all
accounts.length # =>  2

accounts[0].id # =>  1
accounts[0].email 
accounts[0].username

accounts[1].id # =>  2
accounts[1].email
accounts[1].username 

# 2
# Get a single account
repo = AccountRepository.new
account = repo.find(1)

account.id # =>  1
account.email
account.username

# 3
# Create new accoun
repo = AccountRepository.new
account = Account.new
account.email = 'test@example.com'
account.username = 'test'

repo.create(account)

accounts = repo.all
expect(accounts).to include(account) # => true


# 4
# Delete account
repo = AccountRepository.new
repo.delete(id)
accounts = repo.all
expect(accounts).to include(account) # => true

# 5
# Update account email 

repo = AccountRepository.new
account = Account.new(1, 'email', 'newtest@example.com')
accounts = repo.all
expect(accounts[0].email).to eq('newtest@example.com')
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_students_table
  seed_sql = File.read('spec/seeds_students.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'students' })
  connection.exec(seed_sql)
end

describe StudentRepository do
  before(:each) do 
    reset_students_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour
