# jail-dash installation

### Fork the remote repository

### Use docker to run the Microsoft SQL (MSSQL) server
1. Install docker: https://docs.docker.com/docker-for-mac/install/
2. Give docker 4GB of memory: https://docs.docker.com/docker-for-mac/#memory

### Set up ruby and connect to SQL server
https://www.microsoft.com/en-us/sql-server/developer-get-started/ruby/mac/

### Run MSSQL with docker in the background
`docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=SApassword!' -p 1433:1433 -d microsoft/mssql-server-linux`

### Set up the ruby on rails database
1. gem install rails
#### Use bundle to install this app's ruby requirements
2. bundle
3. brew install graphviz
#### (If necessary, change the ruby version in Gemfile)
4. vim Gemfile
5. ruby connect.rb
6. rake db:create
7. rake db:migrate

### Run the rails app
rails s


## Debugging
docker ps -a
docker logs [CONTAINER_NAME]


