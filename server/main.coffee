# `import { Neo4jDB } from 'meteor/ostrio:neo4jdriver'`
Neo4jDB = require('neo4j-fiber').Neo4jDB

Meteor.startup ->
  # Use process.env.NEO4J_URL
  db = new Neo4jDB()

  unless db.queryOne 'MATCH (n) RETURN n LIMIT 1'
    cities = {}
    cities['Zürich'] = db.nodes(
      removed: false
      name: 'Zürich'
      updatedAt: +new Date
      x: 473
      y: 85).labels.set('City')
    cities['Tokyo'] = db.nodes(
      removed: false
      name: 'Tokyo'
      updatedAt: +new Date
      x: 356
      y: 1396).labels.set('City')
    cities['Athens'] = db.nodes(
      removed: false
      name: 'Athens'
      updatedAt: +new Date
      x: 379
      y: 237).labels.set('City')
    cities['Cape Town'] = db.nodes(
      removed: false
      name: 'Cape Town'
      updatedAt: +new Date
      x: -330
      y: 180).labels.set('City')
    cities['Shanghai'] = db.nodes(
      removed: false
      name: 'Shanghai'
      updatedAt: +new Date
      x: 310.230416
      y: 1210.473701).labels.set('City')
    cities['Buenos Aires'] = db.nodes(
      removed: false
      name: 'Buenos Aires'
      updatedAt: +new Date
      x: -340
      y: -580).labels.set('City')
    cities['Bombay'] = db.nodes(
      removed: false
      name: 'Bombay'
      updatedAt: +new Date
      x: 190
      y: 728).labels.set('City')
    cities['Karachi'] = db.nodes(
      removed: false
      name: 'Karachi'
      updatedAt: +new Date
      x: 248
      y: 670).labels.set('City')

    # Add relationship between cities
    # At this example we set km
    cities['Athens'].to cities['Cape Town'], 'ROUTE', km: 8015.08, updatedAt: +new Date
    cities['Zürich'].to cities['Cape Town'], 'ROUTE', km: 1617.27, updatedAt: +new Date
    cities['Cape Town'].to cities['Tokyo'], 'ROUTE', km: 9505.67, updatedAt: +new Date
    cities['Zürich'].to cities['Athens'], 'ROUTE', km: 1617.27, updatedAt: +new Date
    cities['Athens'].to cities['Tokyo'], 'ROUTE', km: 9576.67, updatedAt: +new Date
    cities['Shanghai'].to cities['Buenos Aires'], 'ROUTE', km: 19641, updatedAt: +new Date
    cities['Bombay'].to cities['Karachi'], 'ROUTE', km: 885.21, updatedAt: +new Date


  Meteor.methods
    getPath: (from, to) ->
      check from, Number
      check to, Number
      shortest = db.nodes(from).path(to, "ROUTE", {cost_property: 'km', algorithm: 'dijkstra'})[0]

      if !shortest
        return false
      return {nodes: shortest.nodes, edges: shortest.relationships, km: shortest.weight}

    graph: (timestamp = 0) -> 
      check timestamp, Number
      nodes = {}
      edges = {}

      visGraph = 
        nodes : []
        edges: []
      graph = db.query('MATCH (n) WHERE n.updatedAt >= {timestamp} RETURN DISTINCT n UNION ALL MATCH ()-[n]-() WHERE n.updatedAt >= {timestamp} RETURN DISTINCT n', {timestamp}).fetch()

      if graph.length is 0
        updatedAt = timestamp
      else
        updatedAt = +new Date

        for row in graph
          if row?.n
            if row.n?.start or row.n?.end
              unless edges?[row.n.id]
                edge = 
                  id: row.n.id
                  from: row.n.start
                  to: row.n.end
                  type: row.n.type
                  label: row.n.type
                  arrows: 'to'
                  group: row.n.type
                edges[row.n.id] = _.extend edge, row.n
            else
              unless nodes?[row.n.id]
                node = 
                  id: row.n.id
                  labels: row.n.labels
                  label: row.n.name
                  group: row.n.labels[0]
                nodes[row.n.id] = _.extend node, row.n

        visGraph.edges = (value for key, value of edges)
        visGraph.nodes = (value for key, value of nodes)

      return {updatedAt, data: visGraph}

    createNode: (form) ->
      check form, {
        name: String
      }
      updatedAt = +new Date
      n = db.nodes({name: form.name, updatedAt}).labels.set('City').get()
      n.label = n.name
      n.group = n.labels[0]
      n

    updateNode: (form) ->
      check form, {
        name: String
        id: Number
      }
      form.id = parseInt form.id
      updatedAt = +new Date
      n = db.nodes(form.id).properties.set({name: form.name, updatedAt}).get()
      n.label = n.name
      n.group = n.labels[0]
      n

    deleteNode: (id) ->
      check id, Match.OneOf String, Number
      id = parseInt id

      ###
      First we set node to removed state, so all other clients will remove that node on long-polling
      After 30 seconds we will get rid of the node from Neo4j, if it still exists
      ###
      updatedAt = +new Date
      n = db.nodes id
      unless n.property 'removed'
        n.properties.set 
          removed: true
          updatedAt: updatedAt

        Meteor.setTimeout ->
          n = db.nodes id
          n.delete() if n?.get?()
          return
        , 2000
      true
      
    createRelationship: (form) ->
      check form, Object
      form.to = parseInt form.to
      form.from = parseInt form.from
      form.km = parseFloat form.km

      check form, {
        to: Number
        from: Number
        km: Number
      }

      if form.km < 1
        throw new Meteor.Error 'km can\'t be less than 1km'

      updatedAt = +new Date

      n1 = db.nodes form.from
      n2 = db.nodes form.to

      r = n1.to(n2, 'ROUTE', {km: form.km, updatedAt}).get()
      r.from    = r.start
      r.to      = r.end
      r.label   = r.type
      r.group   = r.type
      r.arrows  = 'to'
      r

    updateRelationship: (form) ->
      check form, Object
      form.to = parseInt form.to
      form.from = parseInt form.from
      form.id = parseInt form.id
      form.km = parseFloat form.km

      check form, {
        to: Number
        from: Number
        id: Number
        km: Number
      }

      if form.km < 1
        throw new Meteor.Error 'km can\'t be less than 1km'

      oldRel = db.relationship.get form.id
      ###
      If this relationship already marked as removed, then it changed by someone else
      We will just wait for long-polling updates on client
      ###
      updatedAt = +new Date
      if oldRel.get()
        unless oldRel.property 'removed'
          # n1 = db.nodes form.from
          # n2 = db.nodes form.to
          # if form.type isnt oldRel.get().type
          #   oldRel.properties.set
          #     removed: true
          #     updatedAt: updatedAt

          #   Meteor.setTimeout ->
          #     r = db.relationship.get form.id
          #     r.delete() if r?.get?()
          #   , 1750

          #   r = n1.to(n2, form.type, {description: form.description, updatedAt}).get()
          # else
          r = oldRel.properties.set({km: form.km, updatedAt}).get()

          r.from    = r.start
          r.to      = r.end
          r.label   = r.type
          r.group   = r.type
          r.arrows  = 'to'
          r
      else
        true

    deleteRelationship: (id) ->
      check id, Match.OneOf String, Number
      id = parseInt id

      ###
      First we set relationship to removed state, so all other clients will remove that relationship on long-polling
      After 15 seconds we will get rid of the relationship from Neo4j, if it still exists
      ###
      updatedAt = +new Date
      r = db.relationship.get id
      
      if r.get() and not r.property 'removed'
        r.properties.set
          removed: true
          updatedAt: updatedAt

        Meteor.setTimeout ->
          r = db.relationship.get id
          r.delete() if r?.get?()
          return
        , 1750
      true

    nodeReposition: (id, coords) ->
      check id, Match.OneOf String, Number
      id = parseInt id
      check coords, x: Number, y: Number
      node = db.nodes(id)

      if node._id && node._node
        node.properties.set 
          updatedAt: +new Date
          x: coords.x
          y: coords.y

      true
  return