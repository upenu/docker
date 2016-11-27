upenu - docker (old!)
========================
Dockerized setup and development of upenu/website
We moved everything here to the upenu/website repo directly, so you can look there for specifics on setting up the website dev stack with containers

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
1. On your machine, `git clone` the upenu/website repo and `cd` into it
    - Make sure to `cp upe/settings.py.template upe/settings.py`, or nothing will work!
    - Also, if you are running OSX or Windows, make sure you `git clone` in a subpath of your `/Users` or `C:\Users` directory respectively
2. Now we're going to create a container and execute some setup commands. Run `docker run -d -it --name upe-syncdb --link upe-mysql:mysql -v /path/to/website:/src/website upenu/website:dev python3 src/website/manage.py syncdb`
    - On OSX, your path should be `/Users/<path_to_website>`
    - On Windows, your path should be like `/c/Users/<path_to_website>`
    - On Linux, you can use just the command `pwd` to get the full path of the website folder when you are inside of it
    - What this command does: `docker run` creates a new docker container to run a command; `-d` makes our container`-it` gives us a pseudo-TTY; `--name upe-syncdb` names our container upe-syncdb; `--link upe-mysql:mysql` links our container with the mysql container we made earlier; `-v /path/to/webite:/src/website` lets our docker container mount the volume on our host machine (lets us edit files easier); and the last part with `python3` just runs a command :)
3. Django should ask you to create a superuser; do so and remember the username and password you use
4. We're done using this container now, so we can remove it: `docker rm upe-syncdb`
5. Now we'll create a new container for running the website. Run this command: `docker run -d -P --name upe-website --link upe-mysql:mysql -v /path/to/website:/src/website -w /src/website upenu/website:dev python3 /src/website/manage.py runserver 0.0.0.0:8000`
6. Docker will automatically map port 8000 in the container to a higher port on our real machine. Use the command `docker ps` to see all of the running containers on your system. For row corresponding to the `upe-website` container, you should see something like `0.0.0.0:32768->8000/tcp`. Go to `localhost:32768` or whatever port number is there in a web browser and bask in the glory of your own version of the upe website!
7. If you ever need to run Django commands etc. in your new docker container, you can use the `docker exec` command like so: `docker exec upe-website python3 manage.py <command>`
    - Note that we have changed our `cwd` (current working directory) of the container to be `/src/website` when we created our container
