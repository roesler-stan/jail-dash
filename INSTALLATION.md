# jail-dash installation

This is a ruby on rails app using Microsoft SQL.  It is used by Jail Dashboard to visualize counties' jail performance: https://www.codeforamerica.org/news/join-the-free-jail-dashboard-pilot.

### Fork the remote repository
https://github.com/codeforamerica/jail-dash

### Use docker to run the Microsoft SQL (MSSQL) server
1. Install docker: https://docs.docker.com/docker-for-mac/install/
2. Give docker 4GB of memory: https://docs.docker.com/docker-for-mac/#memory

### Set up ruby and connect to SQL server
Run the first 1.5 pages of the following:

https://www.microsoft.com/en-us/sql-server/developer-get-started/ruby/mac/

### Run MSSQL with docker in the background
`docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=SApassword!' -p 1433:1433 -d microsoft/mssql-server-linux`

### Set up the ruby on rails database
1. gem install rails
#### Use bundle to install this app's ruby requirements
2. bundle
3. brew install graphviz
#### (If necessary, change the ruby version in Gemfile and .ruby-version)
4. vim Gemfile, vim .ruby-version
#### Set up rails db (see https://www.microsoft.com/en-us/sql-server/developer-get-started/ruby/mac/step/2.html)
#### (To test database: ruby connect.rb)
5. rake db:create
6. rake db:migrate

### Install webpack
1. brew install node
2. brew install yarn
3. bundle exec rails webpacker:install

### Run the rails app
rails s

### Input user name and password
vim app/controllers/application_controller.rb

## Debugging
- docker ps -a
- docker logs [CONTAINER_NAME]


