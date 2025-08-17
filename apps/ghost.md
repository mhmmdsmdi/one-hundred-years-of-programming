# Ghost - open source blogging platforms

## Instalation

```bash

docker pull ghost

```

For `Development`:

```bash

docker run -d --name some-ghost -e NODE_ENV=development -e url=http://localhost:3001 -e database__connection__filename='/var/lib/ghost/content/data/ghost.db' -p 3001:2368 -v /path/to/ghost/blog:/var/lib/ghost/content ghost

```

For `Production`:

```bash

version: "3.3"
services:
  ghost:
    image: ghost:latest
    restart: always
    ports:
      - "2368:2368"
    depends_on:
      - db
    environment:
      url: http://localhost:2368
      database__client: mysql
      database__connection__host: db
      database__connection__user: ghost
      database__connection__password: ghostdbpass
      database__connection__database: ghostdb
    volumes:
      - /home/ghost/content:/var/lib/ghost/content

  db:
    image: mariadb:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: your_mysql_root_password
      MYSQL_USER: ghost
      MYSQL_PASSWORD: ghostdbpass
      MYSQL_DATABASE: ghostdb
    volumes:
      - /home/ghost/mysql:/var/lib/mysql

```
