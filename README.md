## Peek Scheduler API

## Stack

This API was designed and developed to accomplish Peek.com passport coding challenge.

Built using Ruby on Rails-API with SQLite.

Data Base Schema:


![alt text](http://i.imgur.com/oS45J9b.png)

## Test Suite

Partially tested. 

I decided to use Rspec and Test Unit for the sake of practice.

Rspec is testing Data Base associations.

Test Unit is testing routes (controllers).

I didn't test more cases but I would love to do so to discuss in a meeting.


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
  I think that the capacity at the test stage is 12 and not 8 as suggested.

* CASE 2: Test 4/4
  All tests passing.

* MANUAL CASE:
  It is working for other simple bookings.

## Q-A
What complications can you foresee while doing this exercise?

> When assigning boats to scpecific slots I added a field to the timeslots table that is filled by an overlap finder method. This method works well when there is only one overlap because its data type is Integer. 

> I think that converting that field data type into a string and coleccting that information as an array and storing its string representation in the data base can be a way to scale.

> Adding validations and a more rubust availability controller - Scheduler Class - is necesary in order to prevent booking when there is no more availability. At least this is an easy feature to implement, but there are other cases that are possible to happened that will require adding more complexity to the Scheduler Class.

> A different Data Base engine will be needed in order to scale. SQLite was good in order to built this small MVP.

## What I would add. Dynamic Pricing / Revenue Management
> * __Booking's frequency metter__. A method that calculates how frequently bookings are happening and compares that with that days availavility, in order to modify the price if there is an evident peak on demand.
> * __Promotion alert__. If there are 15 minutes before a timeslot begins and the the booking's frequency metter is normal, create a last minute promotion.
> * __Seasonality__. A method that modifies the price related to season specificatoins.

## Comments

> I thought in developing this API with Sinatra beacuse is simple and fast. But instead I used this  challenge to grasp my Rails skills. In the process I learned a lot. Plus I tried to comply with the MVC design pattern as much as possible.

> I TDD the development the structure of the API - Data Base and routes. After that I used Postman to verify the calls responses.

## What's Next

> Let's talk.
