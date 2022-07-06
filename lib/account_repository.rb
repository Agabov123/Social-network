require 'account'

class AccountRepository
    def all 
        accounts = []
        sql = 'SELECT * FROM accounts;'
        result = DatabaseConnection.exec_params(sql, [])
        result.each do |item|
            account = Account.new 
            account.id = item['id']
            account.email = item['email']
            account.username = item['username']
            accounts << account
        end 
        return accounts
    end 

    def find(id)
        sql = 'SELECT * FROM accounts WHERE id = $1;'
        params = [id]
        result = DatabaseConnection.exec_params(sql, params)
        record = result[0]
        account = Account.new
        account.id = record['id']
        account.email = record['email']
        account.username = record['username']

        return account
    end 

    def create(account)
        sql = 'INSERT INTO accounts (id, email, username) VALUES ($1, $2, $3);'
        params = [account.id, account.email, account.username]

        DatabaseConnection.exec_params(sql, params)

        return nil
    end 

    def delete(id)
        sql = 'DELETE FROM accounts WHERE id = $1;'
        DatabaseConnection.exec_params(sql, [id])

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