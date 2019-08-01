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


Scenario: create a new product and get it by id to update it

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

    * def product_id = response.id
    * print 'created id is: ' + product_id

    Given path 'products/' + product_id
    When method get
    Then status 200
    And match response.description contains "Brazilian coffee"

    * def product_update =
    """
    {
      "name": "Coffee",
      "type": "grain",
      "price": 12.50,
      "shipping": 0,
      "upc": "041333424519",
      "description": "Colombian coffee",
      "manufacturer": "coffee roaster",
      "model": "Cerrado mineiro",
      "url": "http://www.bestbuy.com/site/duracell-aa-1-5v-coppertop-batteries-4-pack/48530.p?id=1099385268988&skuId=48530&cmp=RMXCC",
      "image": "http://img.bbystatic.com/BestBuy_US/images/products/4853/48530_sa.jpg"
    }
    """
    Given path 'products/' + product_id
    And request product_update
    When method patch
    Then status 200

Scenario: attempt to create a new product and get http 400 due to a larger model

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

#Scenario: to update an existing product
#* def product_update =
#"""
#{
#  "name": "Coffee",
#  "type": "grain",
#  "price": 12.50,
#  "shipping": 0,
#  "upc": "041333424519",
#  "description": "Colombian coffee",
#  "manufacturer": "coffee roaster",
#  "model": "Cerrado mineiro",
#  "url": "http://www.bestbuy.com/site/duracell-aa-1-5v-coppertop-batteries-4-pack/48530.p?id=1099385268988&skuId=48530&cmp=RMXCC",
#  "image": "http://img.bbystatic.com/BestBuy_US/images/products/4853/48530_sa.jpg"
#}
#"""
#Given path 'products/' + product_id
#And request product_update
#When method patch
#Then status 200



Scenario: to delete an existing store

* def new_store =
"""
{
  "name": "JuiceOne",
  "type": "Grocery",
  "address": "8301 3rd St S",
  "address2": "string",
  "city": "Oakland",
  "state": "NE",
  "zip": "55129",
  "lat": 0,
  "lng": 0,
  "hours": "Mon: 10-9; Tue: 10-9; Wed: 10-9; Thurs: 10-9; Fri: 10-9; Sat: 10-9; Sun: 10-8",
  "services": {
            "id": 1,
            "name": "Geek Squad Services",
            "createdAt": "2016-11-17T17:56:35.881Z",
            "updatedAt": "2016-11-17T17:56:35.881Z",
            "storeservices": {
              "createdAt": "2016-11-17T17:57:08.361Z",
              "updatedAt": "2016-11-17T17:57:08.361Z",
              "storeId": 15,
              "serviceId": 1}
              }
}
"""

    Given path 'stores'
    And request new_store
    When method post
    Then status 201

    * def store_id = response.id

    Given path 'stores/' + store_id
    When method delete
    Then status 200


Scenario Outline: several requests to get stores

    Given path 'stores/<identifier>'
    When method get
    Then status 200
    And match response.name contains '<name>'

    Examples:
        |identifier|name|
        |7         |Roseville|
        |10        |aplewood|
        |11        |Northtown|