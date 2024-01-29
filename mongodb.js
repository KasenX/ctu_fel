// mongosh --port 42222 -u login -p password database
// mongosh --port 42222 -u f231_janecja9 -p hgqENl f231_janecja9

// Example object
/*
{
  _id: ObjectId('5f5b6c45d6f8cbd0e55e7a1e'),
  name: 'Jacob Wilson',
  age: 45,
  address: {
    street: '654 Pine St',
    city: 'Anytown',
    state: 'NY',
    zip: '24689'
  },
  phoneNumbers: [ '555-555-7890', '555-555-1212' ],
  email: 'jacob.wilson@example.com',
  dateOfBirth: ISODate('2000-01-01T00:00:00.000Z'),
  orderHistory: [
    {
      orderId: 'yz123',
      orderDate: ISODate('2020-01-02T05:00:00.000Z'),
      total: 160
    },
    {
      orderId: 'abc456',
      orderDate: ISODate('2020-01-06T05:00:00.000Z'),
      total: 120
    }
  ]
}
*/

// Find all customers who are older than 30 years old
db.customers.aggregate({$addFields: {"age": { $divide: [{$subtract: [new Date(), "$dateOfBirth"]}, (365 * 24 * 60 * 60 * 1000)]}}}, {$match: {"age": {$gte: 20}}});

// Find all customers born before January 1stm 1995
db.customers.find({"dateOfBirth": {$lt: new Date("1995-01-01")}});

// Decrease the total of all orders by 20% for all customers
db.customers.updateMany({}, { $mul: { "orderHistory.$[].total": 0.8 }});

// Update the date of birth for all customers named Bob Johnson to January 1st, 2000.
db.customers.updateMany({"name": "Bob Johnson"}, {$set: {"dateOfBirth": new Date("2000-01-01")}})

// Remove all customers whose order history has order less than $100
db.customers.deleteMany({"orderHistory": { $elemMatch: { "total": {$lte: 120}}}})

// Count number of customers per state
db.customers.aggregate({$group: {"_id": "$address.state", "total": {$sum: 1}}})

// Find the most common phone number among customers
db.customers.aggregate({$unwind: "$phoneNumbers"}, {$group: {"_id": "$phoneNumbers", "total": {$sum: 1}}}, {$sort: {"total": -1}}, {$limit: 1})

// Divide customers by cities and count them
db.customers.aggregate({$group: {"_id": "$address.city", "total": {$sum: 1}}})

// Find the oldest customer
db.customers.find().sort({"dateOfBirth": 1}).limit(1)

/*
Assignment:
{ "_id" : ObjectId(5349b4ddd2781d08c09890f4), "title":"Robin Williams"}
{ "_id" : ObjectId(5349b4ddd2781d08c09890f5), "title":"Tom Hanks"}
{ "_id" : ObjectId(5349b4ddd2781d08c09890f6), "title":"Sean Connery"}

Result:
{"title":"Tom Hanks"}
{"title":"Sean Connery"}
{"title":"Robin Williams"}
*/

db.assignment.find({}, {"_id": 0, "title": 1}).sort({"title": -1});
