# README

This is a Blog API where you can create, show, update and delete Posts.

# Ruby version

`ruby '2.7.3'`

# Configuration

To get a local copy of the API clone the repo with

`git clone git@github.com:pablodonalisio/blog-api.git`

and install dependencies with

`bundle install`

and you're good to go.

# Postman

You can test the API in a local server with this Postman collection

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/f864b61bbb0cf86578d9#?env%5Bblog-api%20-%20Development%5D=W3sia2V5IjoiYmFzZVVybCIsInZhbHVlIjoiaHR0cDovL2xvY2FsaG9zdDozMDAwLyIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoidXNlckVtYWlsIiwidmFsdWUiOiIiLCJlbmFibGVkIjpmYWxzZX0seyJrZXkiOiJ1c2VyRW1haWwiLCJ2YWx1ZSI6IiIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoidG9rZW4iLCJ2YWx1ZSI6IiIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoicG9zdENhdGVnb3J5IiwidmFsdWUiOiIiLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6InBvc3RUaXRsZSIsInZhbHVlIjoiIiwiZW5hYmxlZCI6dHJ1ZX0seyJrZXkiOiJwb3N0SWQiLCJ2YWx1ZSI6IiIsImVuYWJsZWQiOnRydWV9XQ==)

# Usage

To start using the API you need to create a user.

You can create one at

`POST /auth/sign_up`

Query params:

- user[email]
- user[password] (min 6 characters)

Then you need to login to get a Token at

`POST /auth/login`

Query params:

- email
- password

You need the token to make requests to the API.

# Endpoints

To make request to the endpoints you need to add an Authorization header to the HTTP request
like this

`Authorization: Bearer <YourApiToken>`

## Posts

### POST /posts

Allows you to create a Post.

Query params:

- post[tile] (requiered)
- post[img_url]
- post[content]
- post[category_id]

### PATCH /posts/:postId

Allows you to update a Post.

Query params:

- post[tile]
- post[img_url]
- post[content]
- post[category_id]

### GET /posts

Gives you a list of all posts, ordered by creation date (DESC).

Also you can search for posts using this query params:

- title
- category

### GET /posts/:id

Gives you all the attributes from post with the id specified in the URL.

### DELETE /posts/:id

Deletes the post with the id specified in the URL.

# Test suite

To run tests type

`bundle exec rspec`

or a single file test with

`bundle exec rspec <file_location>`
