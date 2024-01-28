//#1
//INCORRECT
db.users.find({ "interests" : ["football", "diving"] })

db. users.find( 
{  interests : { $all: ["football", "diving"] } }
); 

db. users.find( 
{ $and: [ {interests : "football"}, {interests : "diving" } ] } 
);


//#2
db.users.find({
	"home.city": {$in: ["Prague", "Brno"]}, 
	"birthdate": {$lt: new Date("2000-01-01")}
});


//#3
db.users.aggregate([ 
	{ $addFields: { num_friends: { $size: "$friends" } } }, 
	{ $group: { _id: "num_friends", max_friends: { $max: "$num_friends" }}}
])


//#4
db.users.aggregate([ 
	{ $match: { "interests" : { $all: ["football", "party"] } } }, 
	{ $count: "football_and_party_fans" } 
])

//#5
db.checkins.aggregate([
	{ $group : { _id : "$name", count : { $sum: 1 } } },
	{ $sort : { count : -1 } },
	{ $limit : 3 }
])


//#6
db.users.aggregate([ 
{ $match: { "friends" : { $all: [1, 2] } } }, 
{ $sort: { registration_date: -1 } } 
])


//#7
db.checkins.aggregate([
	{ $addFields : { "winter": { $month : "$timestamp" }}}, 
	{ $match : {"winter" : { $in : [12, 1, 2] } } } ,
	{ $group : {_id : "$name", count : { $sum : 1 }}}, 
	{ $sort : {count: -1}}
])


//#8
db.users.aggregate([ 
{ $project: { name: 1, num_of_friends: { $size: "$friends" } } }, 
{ $match: { num_of_friends: { $gt: 3 } } }, 
{ $sort: { num_of_friends: -1 } } 
])

//#9
db.users.aggregate([ 
{ $project: { age: { $subtract: [ new Date(), "$birthdate" ] } } }, 
{ $group: { _id: null, avg_age: { $avg: "$age" } } },
{ $project: {_id: 0, avg_age: 1} }
])

//#10
db.users.aggregate([ 
{ $match: { "registration_date" : { $gt : ISODate("2015-01-01T00:00:00.000Z") } } }, 
{ $sort: { registration_date: -1 } } 
])

//#11
db.users.aggregate([ 
{ $project: { year: { $year: "$registration_date" } } }, 
{ $group: { _id: "$year", count: { $sum: 1 } } } 
])

//#12
db.users.aggregate([ 
{ $match: { "registration_date": { $gt: ISODate("2015-01-01T00:00:00.000Z")}}}, 
{ $group: { _id: "$home.city", 
users: { $push: { name: "$name", surname: "$surname" } } } }, 
{ $replaceRoot: { newRoot: { city: "$_id", users: "$users" } } } 
])

//#13-1
db.users.aggregate([
	{ $addFields : { num_friends : { $size : "$friends"}}},
	{ $sort : { num_friends : -1}},
	{ $project : { name : 1, num_friends : 1 }},
	{ $limit : 1 }
])

//#13-2 – Two queries, slower
// Step 1: Find the maximum number of friends 
var maxFriends = db.users.aggregate([ 
{ $addFields : { num_friends : { $size : "$friends" }}}, 
{ $group: { _id: null, maxFriends: { $max: "$num_friends" }}} 
]).toArray()[0].maxFriends; 

// Step 2: Use the maxFriends value to find all users with that number of friends 
db.users.aggregate([ 
{ $addFields : { num_friends : { $size : "$friends" }}}, 
{ $match : { num_friends : maxFriends }}, 
{ $project : { name : 1, num_friends : 1 }} 
]);

//#13-3 – One query, quicker
db.users.aggregate([ 
{ $addFields: { num_friends: { $size: "$friends" }}}, 
{ $group: { _id: "$num_friends", users: { $push: "$$ROOT" }}}, 
{ $sort: { _id: -1 }}, 
{ $limit: 1 }, 
{ $unwind: "$users" }, 
{ $replaceRoot: { newRoot: "$users" }}, 
{ $project: { name: 1, num_friends: 1 }} 
])


//#14
db.users.aggregate([ 
	{$lookup: { 
		from: "checkins", 
		localField: "_id", 
		foreignField: "user", 
		as: "checkins" 
	} }
]) 


//#15
db.users.aggregate([{
	$lookup: {
		from: "checkins",
		localField: "_id",
		foreignField: "user",
		as: "checkins"
	}
}, 
	{ $addFields: { num_checkins: { $size: "$checkins"} } }, 
	{ $sort: { num_checkins: -1 } }, 
	{ $limit: 3 }
])


//#16
db.users.aggregate([ 
{ $match: { interests: "football" } }, 
{ $lookup: { from: "users", localField: "friends", foreignField: "_id", as: "friends_info" } }, 
{ $project: { name: 1, surname: 1, friends: "$friends_info.name"}}  
])