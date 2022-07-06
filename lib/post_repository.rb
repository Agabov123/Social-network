require 'post'

class PostRepository
    def all 
        posts = []
        sql = 'SELECT * FROM posts;'
        result = DatabaseConnection.exec_params(sql, [])
        result.each do |item|
            post = Post.new 
            post.id = item['id']
            post.title = item['title']
            post.content = item['content']
            post.num_of_views = item['num_of_views']
            posts << post
        end 
        return posts
    end 
    def find(id)
        sql = 'SELECT * FROM posts WHERE id = $1;'
        params = [id]
        result = DatabaseConnection.exec_params(sql, params)
        record = result[0]

        post = Post.new
        post.id = record['id']
        post.title = record['title']
        post.content = record['content']
        post.num_of_views = record['num_of_views']
        return post
    end 

    def create(post)
        sql = 'INSERT INTO posts (id, title, content, num_of_views) VALUES ($1, $2, $3, $4);'
        params = [post.id, post.title, post.content, post.num_of_views]

        DatabaseConnection.exec_params(sql, params)

        return nil
    end

    def delete(id)
        sql = 'DELETE FROM posts WHERE id = $1;'
        DatabaseConnection.exec_params(sql, [id])
        return nil
    end 

    def update(id, col, val) 
        
        if col == 'title'
            sql = 'UPDATE posts SET title = $2 WHERE id = $1;'
        elsif col == 'content'
            sql = 'UPDATE posts SET content = $2 WHERE id = $1;'
        elsif col == 'num_of_views'
            sql = 'UPDATE posts SET num_of_views = $2 WHERE id = $1;'    
        end 
        params = [id, val]
        DatabaseConnection.exec_params(sql, params)

        return nil
    end 
end 
