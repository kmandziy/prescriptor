# README

This is a Rails application for managing medications and dosages.



## Setup

1. Clone the repository

2. Build the docker image
docker-compose build

3. Run the docker container
docker-compose up

4. Run the migrations
docker-compose exec app rails db:migrate

5. Open the application
http://localhost:3001
