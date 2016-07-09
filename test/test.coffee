supertest = require 'supertest'
URL       = 'http://localhost:3000/graphql'
server    = supertest.agent URL
should    = require 'should'

describe 'Unit Test :: Access Home Page', ->

  # curl -XPOST http://localhost:3000/graphql
  it 'should test server is up and running', (done) ->

    server
    .post('/')
    .set('Content-Type', 'application/graphql')
    .expect(200, done)

  # curl -XPOST -H 'Content-Type:application/graphql'  -d '{__schema { queryType { name, fields { name, description} }}}' http://localhost:3000/graphql
  it 'should get __schema', (done)->

    expectedResult = 
    {
      "data": {
        "__schema": {
          "queryType": {
            "name": "RootQueryType",
            "fields": [
              {
                "name": "count",
                "description": "The count!"
              }
            ]
          }
        }
      }
    }      

    server
    .post('/')
    .type('form')
    .set('Content-Type', 'application/graphql')
    .send('{__schema { queryType { name, fields { name, description} }}}')
    .end (err, res)->
      JSON.parse(res.text).should.eql(expectedResult)
      done()

  # curl -XPOST -H'Content-Type:application/graphql' -d '{ count }' http://localhost:3000/graphql
  it 'should get { count }', (done)->

    expectedResult = { data: { count: 0 } }

    server
    .post('/')
    .type('form')
    .set('Content-Type', 'application/graphql')
    .send('{ count }')
    .end (err, res) ->
      res.status.should.equal 200
      JSON.parse(res.text).should.eql(expectedResult)
      done()

  # curl -XPOST -H 'Content-Type:application/graphql' -d 'mutation RootMutationType { updateCount }' http://localhost:3000/graphql
  it 'should mutate { count }', (done)->

    expectedResult = { data: { updateCount: 1 } }

    server
    .post('/')
    .type('form')
    .set('Content-Type', 'application/graphql')
    .send('mutation RootMutationType { updateCount }')
    .end (err,res)->
      JSON.parse(res.text).should.eql(expectedResult)
      done()
  
  # curl -XPOST -H 'Content-Type:application/graphql' -d 'mutation RootMutationType { updateCount }' http://localhost:3000/graphql
  it 'should mutate { count } again', (done)->

    expectedResult = { data: { updateCount: 2 } }

    server
    .post('/')
    .type('form')
    .set('Content-Type', 'application/graphql')
    .send('mutation RootMutationType { updateCount }')
    .end (err,res)->
      JSON.parse(res.text).should.eql(expectedResult)
      done()
  
  # curl -XPOST -H'Content-Type:application/graphql' -d '{ count }' http://localhost:3000/graphql
  it 'should get updated { count }', (done)->

    expectedResult = { data: { count: 2 } }

    server
    .post('/')
    .type('form')
    .set('Content-Type', 'application/graphql')
    .send('{ count }')
    .end (err, res) ->
      res.status.should.equal 200
      JSON.parse(res.text).should.eql(expectedResult)
      done()

