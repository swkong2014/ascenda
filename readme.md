# Ascenda Loyalty technical assignment

This is a sinatra project for the technical assignment

Prepared by Kong Song Wei

## Pre-requisite

The project is developed on windows with Docker-compose using official Ruby 2.6 docker image.

Installing docker-compose: <https://docs.docker.com/compose/install/>

## Getting Started

to get started,

1. clone this repository

``` bash
git clone <https://github.com/swkong2014/ascenda>
```

2. change directory into the cloned folder to run and build the repo using docker-compose

``` bash
> cd ascenda
> docker-compose up --build
```

This step will pull the ruby 2.6 image from docker hub, install all necessary gems, and run the development server using rack.

ensure the server is running by visiting <http://localhost:9292>

Note: if you are facing issues with docker-compose, you can install the gems using <https://bundler.io/> and start local server via rackup

``` bash
> bundle install
> rackup
```

## Running the tests

Unit tests can be run using the docker container using the following command

``` bash
> docker exec -t -i ascenda_web_1 ruby spec/controllers/hotel_info _controller_spec.rb
> docker exec -t -i ascenda_web_1 ruby spec/helpers/hotel_info_helper_spec.rb
```

## Using the API

* list all hotels

  GET <http://localhost:9292/hotel/>

* get hotel via hotel id

  GET <http://localhost:9292/hotel/:id>

* list all hotels by location

  GET <http://localhost:9292/location/>

* list all hotels by specific location

  GET <http://localhost:9292/location/:id>

## Authors

* **Kong Song Wei** - *Initial work* - [swkong2014](https://github.com/swkong2014)
