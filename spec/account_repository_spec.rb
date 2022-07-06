require 'account_repository'

RSpec.describe AccountRepository do 
    def reset_accounts_table
        seed_sql = File.read('spec/seeds.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network' })
        connection.exec(seed_sql)
    end
      
    before(:each) do 
        reset_accounts_table
    end

    it "returns all accounts" do
        repo = AccountRepository.new
        accounts = repo.all
        expect(accounts.length).to eq 4

        expect(accounts[0].id).to eq "1" 
        expect(accounts[0].email).to eq "test1@example.com"
        expect(accounts[0].username).to eq "A"

        expect(accounts[1].id).to eq "2" 
        expect(accounts[1].email).to eq "test2@example.com"
        expect(accounts[1].username).to eq "B"
    end 
    it "returns a single account" do 
        repo = AccountRepository.new
        account = repo.find(1)

        expect(account.id).to eq "1" 
        expect(account.email).to eq "test1@example.com"
        expect(account.username).to eq "A"
    end 

    it "creates new account and returns nil" do 
        repo = AccountRepository.new
        account = Account.new
        account.id = "5"
        account.email = 'test5@example.com'
        account.username = 'test'

        repo.create(account)

        accounts = repo.all
        expect(accounts).to include(
            have_attributes(
                id: account.id,
                email: account.email, 
                username: account.username
            )
        )
    end 

    it "deletes account" do 
        repo = AccountRepository.new
        repo.delete(1)
        accounts = repo.all
        expect(accounts.length).to eq 3
    end

    it "cahnges email" do # 
        repo = AccountRepository.new
        repo.update(1, 'email', "newtest@example.com")
        accounts = repo.all
        expect(accounts[3].id).to eq "1"
        expect(accounts[3].email).to eq "newtest@example.com"
        expect(accounts[3].username).to eq "A"
    end

    it "changes username" do  
        repo = AccountRepository.new
        repo.update(2, 'username', "Sven")
        accounts = repo.all
        expect(accounts[3].id).to eq "2"
        expect(accounts[3].email).to eq "test2@example.com"
        expect(accounts[3].username).to eq "Sven"
    end
    
end 