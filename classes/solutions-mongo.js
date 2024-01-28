
// -----------------------------------------------------------------------------

//db = db.getSiblingDB('svoboda')

// -----------------------------------------------------------------------------

db.actors.insert({ _id: "trojan", name: "Ivan Trojan" });
db.actors.insert({ _id: 2, name: "Jiri Machacek" });
db.actors.insert({ _id: ObjectId(), name: "Jitka Schneiderova" });
db.actors.insert({ name: "Zdenek Sverak" });

db.actors.find();

// -----------------------------------------------------------------------------

db.actors.update({ _id: "trojan" }, { name: "Ivan Trojan", year: 1964 });
db.actors.update({ name: "Ivan Trojan", year: { $lt: 2000 } }, { name: "Ivan Trojan", year: 1964 });

db.actors.find({ _id: "trojan" });

// -----------------------------------------------------------------------------

db.actors.update({ _id: "geislerova" }, { name: "Anna Geislerova" }, { upsert: true });

// -----------------------------------------------------------------------------

db.actors.update({ _id: "trojan" }, { _id: 1, name: "Ivan Trojan", year: 1964 });

// -----------------------------------------------------------------------------

db.actors.update(
    { _id: "trojan" },
    {
        $set: { year: 1964, age: 52 },
        $inc: { rating: 1 },
        $push: { movies: { $each: [ "samotari", "medvidek" ] } }
    }
)

db.actors.update(
    { year: { $lt: 2000 } },
    { $set: { rating: 3 } },
    { multi: true }
)

// -----------------------------------------------------------------------------

db.actors.save({ name: "Tatiana Vilhelmova" });
db.actors.save({ _id: 6, name: "Sasa Rasilov" });

db.actors.save({ _id: "trojan", name: "Ivan Trojan", year: 1964 });

// -----------------------------------------------------------------------------

db.actors.remove({ _id: "geislerova" });

db.actors.remove({ year: { $lt: 2000 } }, { justOne: true });

db.actors.remove({ });

// -----------------------------------------------------------------------------

db.actors.insert({ _id: "trojan", name: "Ivan Trojan", year: 1964, movies: [ "samotari", "medvidek" ] });
db.actors.insert({ _id: "machacek", name: "Jiri Machacek", year: 1966, movies: [ "medvidek", "vratnelahve", "samotari" ] });
db.actors.insert({ _id: "schneiderova", name: "Jitka Schneiderova", year: 1973, movies: [ "samotari" ] });
db.actors.insert({ _id: "sverak", name: "Zdenek Sverak", year: 1936, movies: [ "vratnelahve" ] });
db.actors.insert({ _id: "geislerova", name: "Anna Geislerova", year: 1976 });

// -----------------------------------------------------------------------------

db.actors.find();
db.actors.find({ });

db.actors.find({ _id: "trojan" });
db.actors.find({ name: "Ivan Trojan", year: 1964 });

db.actors.find({ year: { $gte: 1960, $lte: 1980 } });
db.actors.find({ movies: { $exists: true } });

db.actors.find({ movies: "medvidek" });
db.actors.find({ movies: { $in: [ "medvidek", "pelisky" ] } });
db.actors.find({ movies: { $all: [ "medvidek", "pelisky" ] } });

db.actors.find({ $or: [ { year: 1964 }, { rating: { $gte: 3 } } ] });
db.actors.find({ rating: { $not: { $gte: 3 } } });

db.actors.find({ }, { name: 1, year: 1});
db.actors.find({ }, { movies: 0, _id: 0 });
db.actors.find({ }, { name: 1, movies: { $slice: 2 }, _id: 0 });

db.actors.find().sort({ year: 1, name: -1 });
db.actors.find().sort({ name: 1 }).skip(1).limit(2);
db.actors.find().sort({ name: 1 }).limit(2).skip(1);

// -----------------------------------------------------------------------------

db.actors.find({ movies: "medvidek" });

db.actors.find({ movies: "medvidek" }).explain();

db.actors.createIndex({ movies : 1 });

// -----------------------------------------------------------------------------

db.actors.mapReduce(
    function() {
        emit(this.year, this.name);
    },
    function(key, values) {
        return values.sort();
    },
    {
        query: { year: { $lte: 2000 } },
        out: { inline: 1 }
    }
);

db.actors.mapReduce(
    function() {
        if (this.movies) {
            this.movies.forEach(
                function(m) { emit(m, 1); }
            );
        }
    },
    function(key, values) {
        return Array.sum(values);
    },
    { out: { inline: 1 } }
);

db.actors.mapReduce(
    function() {
        this.movies.forEach(
            function(m) { emit(m, 1); }
        );
    },
    function(key, values) {
        return Array.sum(values);
    },
    {
        query: { movies: { $exists: true } },
        out: { inline: 1 }
    }
);

db.actors.mapReduce(
    function() {
        if (Array.isArray(this.movies)) {
            this.movies.forEach(
                function(m) { emit(m, 1); }
            );
        } else {
            emit(this.movies, 1);
        }
    },
    function(key, values) {
        return Array.sum(values);
    },
    {
        query: { movies: { $exists: true } },
        out: { inline: 1 }
    }
);

// -----------------------------------------------------------------------------

//db.dropDatabase();

// -----------------------------------------------------------------------------
