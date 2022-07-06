require 'post_repository'

RSpec.describe PostRepository do 
    def reset_posts_table
        seed_sql = File.read('spec/seeds.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network' })
        connection.exec(seed_sql)
    end
      
    before(:each) do 
        reset_posts_table
    end
    it "returns all posts" do 
        repo = PostRepository.new
        posts = repo.all
        expect(posts.length).to eq 4

        expect(posts[0].id).to eq "1" 
        expect(posts[0].title).to eq "A"
        expect(posts[0].content).to eq "some words1"
        expect(posts[0].num_of_views).to eq "1"

        expect(posts[1].id).to eq "2" 
        expect(posts[1].title).to eq "B"
        expect(posts[1].content).to eq "some words2"
        expect(posts[1].num_of_views).to eq "2"
    end 
    it "returns a single post" do 
        repo = PostRepository.new
        post = repo.find(1)

        expect(post.id).to eq "1" 
        expect(post.title).to eq "A"
        expect(post.content).to eq "some words1"
        expect(post.num_of_views).to eq "1"
    end 
    it "creates new post and returns nil" do 
        repo = PostRepository.new
        post = Post.new
        post.id = "5"
        post.title = "new"
        post.content = "some new words"
        post.num_of_views = "0"

        repo.create(post)

        posts = repo.all
        expect(posts).to include(
            have_attributes(
                id: post.id,
                title: post.title,
                content: post.content,
                num_of_views: post.num_of_views
            )
        )
    end
    it "deletes post" do 
        repo = PostRepository.new
        repo.delete(1)
        posts = repo.all
        expect(posts.length).to eq 3
    end
    it "changes title" do  
        repo = PostRepository.new
        repo.update(2, 'title', "NewTitle")
        posts = repo.all
        expect(posts[3].id).to eq "2"
        expect(posts[3].title).to eq "NewTitle"
        expect(posts[3].content).to eq "some words2"
        expect(posts[3].num_of_views).to eq "2"
    end

    it "changes contents" do  
        repo = PostRepository.new
        repo.update(2, 'content', "NewContents")
        posts = repo.all
        expect(posts[3].id).to eq "2"
        expect(posts[3].title).to eq "B"
        expect(posts[3].content).to eq "NewContents"
        expect(posts[3].num_of_views).to eq "2"
    end
    it "changes num_of_views" do  
        repo = PostRepository.new
        repo.update(2, 'num_of_views', "999999")
        posts = repo.all
        expect(posts[3].id).to eq "2"
        expect(posts[3].title).to eq "B"
        expect(posts[3].content).to eq "some words2"
        expect(posts[3].num_of_views).to eq "999999"
    end
end 