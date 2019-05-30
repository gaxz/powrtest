# README
The application receives the token from github and saves the user data to the database and session. Re-authorization checks if user is already in database by name and updates his access token if true. 

# Ruby version
2.6.1

# Rails version
5.2.3

# Deployment instructions
1. Clone repository
2. Rails s -d (domain http://localhost:3000 required)
2. rake db:migrate
3. rake db:seed
4. Thats all i hope
