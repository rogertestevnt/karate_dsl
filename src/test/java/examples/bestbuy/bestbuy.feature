Feature: sample karate test script
    Using best buy api-playground

Background:
* url 'http://localhost:3030/'

Scenario: get all products

Given path 'products'
When method get
Then status 200

* def answer = response
* print 'response is ' + answer


Scenario: get product by id

Given path 'products/150115'
When method get
Then status 200

* def answer = response
* print 'response is ' + answer


Scenario: create a new product and get it by id

* def product =
"""
{
  "name": "Coffee",
  "type": "grain",
  "price": 12.50,
  "shipping": 0,
  "upc": "041333424519",
  "description": "Brazilian coffee",
  "manufacturer": "coffee roaster",
  "model": "Cerrado mineiro",
  "url": "http://www.bestbuy.com/site/duracell-aa-1-5v-coppertop-batteries-4-pack/48530.p?id=1099385268988&skuId=48530&cmp=RMXCC",
  "image": "http://img.bbystatic.com/BestBuy_US/images/products/4853/48530_sa.jpg"
}
"""

Given path 'products'
And request product
When method post
Then status 201
And match response.name contains "Coffee"

* def id = response.id
* print 'created id is: ' + id

Given path 'products/'+id
When method get
Then status 200
And match response.description contains "Brazilian coffee"

Scenario: attempt to create a new product and get http 400

* def product =
"""
{
  "name": "Coffee",
  "type": "grain",
  "price": 12.50,
  "shipping": 0,
  "upc": "041333424519",
  "description": "Brazilian coffee",
  "manufacturer": "coffee roaster",
  "model": "Cerrado mineiro com torra media e espessura fina",
  "url": "http://www.bestbuy.com/site/duracell-aa-1-5v-coppertop-batteries-4-pack/48530.p?id=1099385268988&skuId=48530&cmp=RMXCC",
  "image": "http://img.bbystatic.com/BestBuy_US/images/products/4853/48530_sa.jpg"
}
"""

Given path 'products'
And request product
When method post
Then status 400
And match response.errors contains "'model' should NOT be longer than 25 characters"
And match response.name contains "BadRequest"
