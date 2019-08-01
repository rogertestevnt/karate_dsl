Karateka

This project is a sample for Karate DSL usage.

It uses BestBuy api-playground for executing the tests.

The Best Buy API Playground is an API training tool for students, educators and other learners 
to explore the possibilities of a fully functional RESTful API in a simple, 
non-production environment.

From this url it is possible to get the API running:
https://github.com/BestBuy/api-playground

For running the tests, execute $mvn verify, or alternatively: $mvn test -Dtest=[TestRunner], 
e.g. mvn test -Dtest=BestBuyRunner
