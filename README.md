# jail-dash
A tool to help jail administrators, judges, and other stakeholders understand the conditions in metro jails, and use this data to visualize how their decisions–at both the individual and policy level–affect program, facility, and inmate outcomes.

https://www.microsoft.com/en-us/sql-server/developer-get-started/ruby/mac/

Important notes while following this tutorial:
* BE SURE TO GIVE DOCKER 4GB OF MEMORY (as egregious as that is), as MSSQL won't even start with anything less than 3.25GB
* There are password requirements when setting up the DB. The password in the `database.yml` file should work nicely. The full Docker setup command using that password is: `docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=SApassword!' -p 1433:1433 -d microsoft/mssql-server-linux`
* If you're having trouble starting teh Docker DB, keeping it running, or connecting to it, you may find it helpful to run `docker logs [CONTAINER_NAME]`, where `CONTAINER_NAME` is the hash shown for the container when you run `docker ps -a`
