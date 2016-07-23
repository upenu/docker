upenu - docker
========================
Dockerized setup and development of upenu/website


## Instructions for Development
### Docker and MySQL
1. Install [Docker](https://docs.docker.com/engine/installation/mac/) and read up a little about [how it works](https://docs.docker.com/engine/understanding-docker/)
    - I recommend checking out [some of](https://docs.docker.com/engine/getstarted/) the [tutorials](https://docs.docker.com/engine/tutorials/dockerizing/) to get a hang of what you're doing
2. If you haven't started your docker daemon yet, run the command `sudo service docker start`
3. Run the following command: `docker run --name upe-mysql -e MYSQL_ROOT_PASSWORD=littlewhale -d mysql/mysql-server:5.5`
    - This creates and runs a docker based off of mysql's official ver 5.5 docker image, names it "upe-mysql", and sets the root password to "littlewhale". You can use the command `docker ps` to list running conainers and verify that it is running.
4. We'll need to shell into your mysql server you just created and run some SQL commands. Run the following command: `docker run -it --link upe-mysql:mysql --rm mysql/mysql-server:5.5 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'`
5. Now that you've entered the shell, we'll create the `upe` database with the command `CREATE DATABASE upe;`
6. We'll also create an admin user, and grant it privileges. Run `CREATE USER admin IDENTIFIED BY 'littlewhale';` and then `GRANT ALL PRIVILEGES ON upe.* TO 'admin';`
7. Type `\q` to quit the mysql server shell

### Docker and Django
1. Let's build the docker image we'll be running the webserver in! Run the command `docker build -t 'https://github.com/upenu/docker.git'`
    - This gets the `Dockerfile` from this repository and starts building an image for you
1. On your machine, `git clone` the upenu/website repo and `cd` into it
    - Make sure to `mv upe/settings.py.template upe/settings.py`, or nothing will work!
2. Now run `docker run -d -P`
