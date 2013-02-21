[![Build Status](https://travis-ci.org/Mamuuut/Barricade.png)](https://travis-ci.org/Mamuuut/Barricade)

Barricade
=========

[Board game](http://en.wikipedia.org/wiki/Malefiz) using Express and MongoDB  
This project is based on the [Espresso Boilerplate](http://www.espressoboilerplate.org/)

Install and run
---------
Install the node packages
<pre>
$ npm install
</pre>
Run the mongo DB
<pre>
$ path/to/mongodb/bin/mongod --dbpath ./db/
</pre>
Start the server
<pre>
$ coffee app.coffee
</pre>
You can known check http://localhost:3000 in your browser  
To create a new account just fill in **Username** and **Password** inputs and click on **Log In**  
If the Username does not already exist, a new account will be created.

Implemented features
---------

*   Login
*   Chat
*   Game list
*   Barricade board view

TODO list
---------

*   Add Client game logic
*   Add game schema for mongoDB
*   Add Server game logic
*   Add password encryption
*   ...

Frameworks and libs
---------

*   [Express](http://expressjs.com/)
*   [Espresso](Boilerplate http://www.espressoboilerplate.org/)
*   [Passport](http://passportjs.org/)
*   [Mongoose](http://mongoosejs.com/)
*   [CoffeeScript](http://coffeescript.org/)
*   [Jade](http://jade-lang.com/)
*   [Stylus](http://learnboost.github.com/stylus/)
*   [RequireJS](http://requirejs.org/)
