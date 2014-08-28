## Peek Scheduler API

## Stack

Ruby on Rails API with SQLite database.
The API was designed and developed to accomplish Peeks.com passport coding challenge.

Data Base Schema.
![alt text](http://i.imgur.com/oS45J9b.png)

## Test Suit

Partially tested.
I decided to use Rspec and Test Unit for the sake of practice.

Rspec is testing Data Base associations.

Test Unit is testing routes (controllers).


## Install instructions.

Here's how to get it running:
  * `git clone` this repo to your local box
  * do `bundle install` in the peek_api home directory
  * do `rails s` in the peek_api home directory
  * the API will running in port 3000

## API specification.

All routes plularized to meet scheduling client requirents..

####POST /api/timeslots - create a timeslot
####GET /api/timeslots - list timeslots


####POST /api/boats - create a boat
####GET /api/boats - list boats


####POST /api/assignments - assign boat to timeslot
####GET /api/assignments - list assignments


####POST /api/bookings - create a booking
####GET /api/bookings - list bookings.

## Accomplishments

* CASE 1: Test 1/2
  I think that the capacity at the test stage is 12 and not 8 as sugested.

* CASE 2: Test 4/4
  All test passing.

* MANUAL CASE:
  It is working for other simple booking.

## Q-A
What complications can you foresee while doing this exercise?

> When assigning boats to scpecific slots I added a filed to the timeslots table that is fill by a overlap finder method. This method works well when there is only one overlap. I think that converting that field data type into a string and coleccting that information as an array and storing it's string representation in the data base can be a way to scale.
> Adding validations and a more rubust availability controller is necesary in order to do not let booking happend when there is not more availability. At least this is a easy feature to implement, but there are other cases that are possible to happened that will require adding more complexity to the Scheduler class.

## Comments

> I thought in developing this API with Sinatra beacuse is simple and fast.
> But instead I use this  challenge to grasp my Rails skills.
> In the process I learned a lot.
> Plus I tried to complay to the MVC design pattern as much as possible.
> Plus I TDD the development the structure of the API - Data Base and routes.
> After that I used Postman to verify the calls responses.

## What's Next

> Let's talk, I didn't test more cases
