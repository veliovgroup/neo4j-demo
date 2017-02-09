const Neo4jDB  = require('meteor/ostrio:neo4jdriver').Neo4jDB;
const R        = 6371; // Radius of the earth in km
const deg2rad  = (deg) => deg * (Math.PI / 180);
const getDistance = (lat1, lon1, lat2, lon2) => {
  const dLat = deg2rad(lat2 - lat1);
  const dLon = deg2rad(lon2 - lon1);
  const a    = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
  return (R * (2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))));
};


Meteor.startup(function () {
  // Use process.env.NEO4J_URL
  const db = new Neo4jDB();
  if (!db.queryOne('MATCH (n) RETURN n LIMIT 1')) {
    const airports = require('./airports.js').default;
    const apNodes  = [];
    let distance, city1, city2, city3, _city3, _id;
    airports.forEach((airport, i) => {
      // Load only first 75 airports
      if (i < 75) {
        apNodes.push(db.nodes({
          removed: false,
          name: airport.city,
          updatedAt: +new Date(),
          x: Math.round(airport.lon * 100),
          y: Math.round(airport.lat * 100),
          lat: airport.lat,
          lon: airport.lon,
        }).labels.set('Airport'));

        if (i > 0) {
          city1    = apNodes[i].get();
          city2    = apNodes[i - 1].get();
          distance = Math.round(getDistance(city1.lat, city1.lon, city2.lat, city2.lon));
          apNodes[i].to(apNodes[i - 1], 'ROUTE', {km: distance, updatedAt: +new Date()});
          apNodes[i - 1].to(apNodes[i], 'ROUTE', {km: distance, updatedAt: +new Date()});

          if (i > 10) {
            _id    = Math.floor(Math.random() * (apNodes.length - 2));
            _city3 = apNodes[_id];
            city3  = _city3.get();

            distance = Math.round(getDistance(city1.lat, city1.lon, city3.lat, city3.lon));
            apNodes[i].to(_city3, 'ROUTE', {km: distance, updatedAt: +new Date()});
            _city3.to(apNodes[i], 'ROUTE', {km: distance, updatedAt: +new Date()});

            distance = Math.round(getDistance(city3.lat, city3.lon, city2.lat, city2.lon));
            _city3.to(apNodes[i - 1], 'ROUTE', {km: distance, updatedAt: +new Date()});
            apNodes[i - 1].to(_city3, 'ROUTE', {km: distance, updatedAt: +new Date()});
          }
        }
      }
    });
  }

  Meteor.methods({
    getPath: function (from, to) {
      check(from, Number);
      check(to, Number);

      const shortest = db.nodes(from).path(to, 'ROUTE', {
        cost_property: 'km',
        algorithm: 'dijkstra'
      })[0];

      if (!shortest) {
        return false;
      }

      return {
        nodes: shortest.nodes,
        edges: shortest.relationships,
        km: shortest.weight
      };
    },
    graph: function (timestamp) {
      if (timestamp == null) {
        timestamp = 0;
      }
      check(timestamp, Number);
      const nodes = {};
      const edges = {};
      const visGraph = {
        nodes: [],
        edges: []
      };

      const graph = db.query('MATCH (n) WHERE n.updatedAt >= {timestamp} RETURN DISTINCT n UNION ALL MATCH ()-[n]-() WHERE n.updatedAt >= {timestamp} RETURN DISTINCT n', {
        timestamp: timestamp
      }).fetch();

      let updatedAt;
      if (graph.length === 0) {
        updatedAt = timestamp;
      } else {
        updatedAt = +new Date();
        for (var i = 0; i < graph.length; i++) {
          if (graph[i] != null ? graph[i].n : void 0) {
            if ((graph[i].n != null && graph[i].n.start != null) || (graph[i].n != null && graph[i].n.end != null)) {
              if (!edges[graph[i].n.id]) {
                edges[graph[i].n.id] = _.extend({
                  id: graph[i].n.id,
                  from: graph[i].n.start,
                  to: graph[i].n.end,
                  type: graph[i].n.type,
                  label: graph[i].n.type,
                  arrows: 'to',
                  group: graph[i].n.type
                }, graph[i].n);
              }
            } else {
              if (!nodes[graph[i].n.id]) {
                node = {
                  id: graph[i].n.id,
                  labels: graph[i].n.labels,
                  label: graph[i].n.name,
                  group: graph[i].n.labels[0]
                };
                nodes[graph[i].n.id] = _.extend(node, graph[i].n);
              }
            }
          }
        }

        visGraph.edges = (() => {
          const results = [];
          for (let key in edges) {
            results.push(edges[key]);
          }
          return results;
        })();
        visGraph.nodes = (() => {
          const results = [];
          for (let key in nodes) {
            results.push(nodes[key]);
          }
          return results;
        })();
      }

      return {
        updatedAt: updatedAt,
        data: visGraph
      };
    },
    createNode: function (form) {
      check(form, {
        name: String
      });

      const n = db.nodes({
        name: form.name,
        updatedAt: +new Date()
      }).labels.set('City').get();
      n.label = n.name;
      n.group = n.labels[0];
      return n;
    },
    updateNode: function (form) {
      check(form, {
        name: String,
        id: Number
      });
      form.id = parseInt(form.id);
      const n = db.nodes(form.id).properties.set({
        name: form.name,
        updatedAt: +new Date()
      }).get();
      n.label = n.name;
      n.group = n.labels[0];
      return n;
    },
    deleteNode: function (id) {
      check(id, Match.OneOf(String, Number));
      id = parseInt(id);
      /*
      First we set node to removed state, so all other clients will remove that node on long-polling
      After 30 seconds we will get rid of the node from Neo4j, if it still exists
       */
      let n = db.nodes(id);
      if (!n.property('removed')) {
        n.properties.set({
          removed: true,
          updatedAt: +new Date()
        });

        Meteor.setTimeout(() => {
          n = db.nodes(id);
          if (n != null && typeof n.get === 'function' && n.get()) {
            n.delete();
          }
        }, 2000);
      }
      return true;
    },
    createRelationship: function (form) {
      check(form, Object);
      form.to   = parseInt(form.to);
      form.from = parseInt(form.from);
      form.km   = parseFloat(form.km);

      check(form, {
        to: Number,
        from: Number,
        km: Number
      });

      if (form.km < 1) {
        throw new Meteor.Error('km can\'t be less than 1km');
      }

      const n1 = db.nodes(form.from);
      const n2 = db.nodes(form.to);
      const r  = n1.to(n2, 'ROUTE', {
        km: form.km,
        updatedAt: +new Date()
      }).get();
      r.from = r.start;
      r.to = r.end;
      r.label = r.type;
      r.group = r.type;
      r.arrows = 'to';
      return r;
    },
    updateRelationship: function (form) {
      check(form, Object);
      form.to = parseInt(form.to);
      form.from = parseInt(form.from);
      form.id = parseInt(form.id);
      form.km = parseFloat(form.km);
      check(form, {
        to: Number,
        from: Number,
        id: Number,
        km: Number
      });
      if (form.km < 1) {
        throw new Meteor.Error('km can\'t be less than 1km');
      }
      const oldRel = db.relationship.get(form.id);

      /*
      If this relationship already marked as removed, then it changed by someone else
      We will just wait for long-polling updates on client
       */
      if (oldRel.get()) {
        if (!oldRel.property('removed')) {
          const r = oldRel.properties.set({
            km: form.km,
            updatedAt: +new Date()
          }).get();

          r.from = r.start;
          r.to = r.end;
          r.label = r.type;
          r.group = r.type;
          r.arrows = 'to';
          return r;
        }
      } else {
        return true;
      }
    },
    deleteRelationship: function (id) {
      check(id, Match.OneOf(String, Number));
      id = parseInt(id);

      /*
      First we set relationship to removed state, so all other clients will remove that relationship on long-polling
      After 15 seconds we will get rid of the relationship from Neo4j, if it still exists
       */
      let r = db.relationship.get(id);
      if (r.get() && !r.property('removed')) {
        r.properties.set({
          removed: true,
          updatedAt: +new Date()
        });

        Meteor.setTimeout(() => {
          r = db.relationship.get(id);
          if (r != null && typeof r.get === 'function' && r.get()) {
            r.delete();
          }
        }, 1750);
      }
      return true;
    },
    nodeReposition: function (id, coords) {
      check(id, Match.OneOf(String, Number));
      check(coords, {
        x: Number,
        y: Number
      });
      id = parseInt(id);
      const node = db.nodes(id);
      if (node._id && node._node) {
        node.properties.set({
          updatedAt: +new Date(),
          x: coords.x,
          y: coords.y
        });
      }
      return true;
    }
  });
});
