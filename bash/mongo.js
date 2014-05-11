/*global db: true, DB, DBCollection, ObjectId */
/*jshint unused:false */

var id = function(id) {
  return new ObjectId(id);
};

DBCollection.prototype.id = function(id) {
  return this.findOne({_id: new ObjectId(id) });
};

DBCollection.prototype.un = function(un) {
  return this.findOne({username: un});
};
