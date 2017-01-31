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
    cities['Istanbul Ili'] = db.nodes(
      removed: false
      name: 'Istanbul Ili'
      updatedAt: +new Date
      x: 411
      y: 287).labels.set('City') 
    cities['Mexico City'] = db.nodes(
      removed: false
      name: 'Mexico City'
      updatedAt: +new Date
      x: 194
      y: -991).labels.set('City')
    cities['Istanbul'] = db.nodes(
      removed: false
      name: 'Istanbul'
      updatedAt: +new Date
      x: 410
      y: 289).labels.set('City')  
    cities['Delhi'] = db.nodes(
      removed: false
      name: 'Delhi'
      updatedAt: +new Date
      x: 287
      y: 771).labels.set('City')  
    cities['Manila'] = db.nodes(
      removed: false
      name: 'Manila'
      updatedAt: +new Date
      x: 145
      y: 1209).labels.set('City')
    cities['Moskva'] = db.nodes(
      removed: false
      name: 'Moskva'
      updatedAt: +new Date
      x: 557
      y: 376).labels.set('City')    
    cities['Dhaka'] = db.nodes(
      removed: false
      name: 'Dhaka'
      updatedAt: +new Date
      x: 238
      y: 904).labels.set('City')  
    cities['Seoul'] = db.nodes(
      removed: false
      name: 'Seoul'
      updatedAt: +new Date
      x: 375
      y: 1269).labels.set('City') 
    cities['Sao Paulo'] = db.nodes(
      removed: false
      name: 'Sao Paulo'
      updatedAt: +new Date
      x: -235
      y: -466).labels.set('City')  
    cities['Lagos'] = db.nodes(
      removed: false
      name: 'Lagos'
      updatedAt: +new Date
      x: 65
      y: 33).labels.set('City')
    cities['Ogoyo'] = db.nodes(
      removed: false
      name: 'Ogoyo'
      updatedAt: +new Date
      x: 530
      y: 1586).labels.set('City')
    cities['Jakarta'] = db.nodes(
      removed: false
      name: 'Jakarta'
      updatedAt: +new Date
      x: -61
      y: 1068).labels.set('City')
    cities['Tokyo'] = db.nodes(
      removed: false
      name: 'Tokyo'
      updatedAt: +new Date
      x: 356
      y: 1396).labels.set('City')
    cities['New York City'] = db.nodes(
      removed: false
      name: 'New York City'
      updatedAt: +new Date
      x: 407
      y: -740).labels.set('City')
    cities['Taipei'] = db.nodes(
      removed: false
      name: 'Taipei'
      updatedAt: +new Date
      x: 250
      y: 1215).labels.set('City')
    cities['Kinshasa'] = db.nodes(
      removed: false
      name: 'Kinshasa'
      updatedAt: +new Date
      x: -43
      y: 159).labels.set('City')
    cities['Lima'] = db.nodes(
      removed: false
      name: 'Lima'
      updatedAt: +new Date
      x: -120
      y: -770).labels.set('City')
    cities['Cairo'] = db.nodes(
      removed: false
      name: 'Cairo'
      updatedAt: +new Date
      x: 300
      y: 312).labels.set('City')
    cities['Beijing'] = db.nodes(
      removed: false
      name: 'Beijing'
      updatedAt: +new Date
      x: 399
      y: 1164).labels.set('City')
    cities['London'] = db.nodes(
      removed: false
      name: 'London'
      updatedAt: +new Date
      x: 515
      y: -1).labels.set('City')
    cities['Tehran'] = db.nodes(
      removed: false
      name: 'Tehran'
      updatedAt: +new Date
      x: 356
      y: 513).labels.set('City')
    cities['Nanchong'] = db.nodes(
      removed: false
      name: 'Nanchong'
      updatedAt: +new Date
      x: 308
      y: 1061).labels.set('City')
    cities['Bogota'] = db.nodes(
      removed: false
      name: 'Bogota'
      updatedAt: +new Date
      x: 47
      y: -740).labels.set('City')
    cities['Hong Kong'] = db.nodes(
      removed: false
      name: 'Hong Kong'
      updatedAt: +new Date
      x: 223
      y: 1141).labels.set('City')
    cities['Lahore'] = db.nodes(
      removed: false
      name: 'Lahore'
      updatedAt: +new Date
      x: 315
      y: 743).labels.set('City')
    cities['Rio de Janeiro'] = db.nodes(
      removed: false
      name: 'Rio de Janeiro'
      updatedAt: +new Date
      x: -229
      y: -431).labels.set('City')
    cities['Baghdad'] = db.nodes(
      removed: false
      name: 'Baghdad'
      updatedAt: +new Date
      x: 333
      y: 443).labels.set('City')
    cities['Tai\'an'] = db.nodes(
      removed: false
      name: 'Tai\'an'
      updatedAt: +new Date
      x: 362
      y: 1170).labels.set('City') 
    cities['Bangkok'] = db.nodes(
      removed: false
      name: 'Bangkok'
      updatedAt: +new Date
      x: 137
      y: 1005).labels.set('City') 
    cities['Bengalooru'] = db.nodes(
      removed: false
      name: 'Bengalooru'
      updatedAt: +new Date
      x: 129
      y: 775).labels.set('City')
    cities['Santiago'] = db.nodes(
      removed: false
      name: 'Santiago'
      updatedAt: +new Date
      x: -334
      y: -706).labels.set('City')
    cities['Kaifeng'] = db.nodes(
      removed: false
      name: 'Kaifeng'
      updatedAt: +new Date
      x: 347
      y: 1143).labels.set('City')
    cities['Calcutta'] = db.nodes(
      removed: false
      name: 'Calcutta'
      updatedAt: +new Date
      x: 225
      y: 883).labels.set('City')
    cities['Toronto'] = db.nodes(
      removed: false
      name: 'Toronto'
      updatedAt: +new Date
      x: 436
      y: -793).labels.set('City')
    cities['Rangoon'] = db.nodes(
      removed: false
      name: 'Rangoon'
      updatedAt: +new Date
      x: 168
      y: 961).labels.set('City')
    cities['Sydney'] = db.nodes(
      removed: false
      name: 'Sydney'
      updatedAt: +new Date
      x: -338
      y: 1512).labels.set('City')
    cities['Madras'] = db.nodes(
      removed: false
      name: 'Madras'
      updatedAt: +new Date
      x: 130
      y: 802).labels.set('City')
    cities['Riyadh'] = db.nodes(
      removed: false
      name: 'Riyadh'
      updatedAt: +new Date
      x: 247
      y: 466).labels.set('City')
    cities['Wuhan'] = db.nodes(
      removed: false
      name: 'Wuhan'
      updatedAt: +new Date
      x: 305
      y: 1143).labels.set('City')
    cities['Saint Petersburg'] = db.nodes(
      removed: false
      name: 'Saint Petersburg'
      updatedAt: +new Date
      x: 599
      y: 303).labels.set('City')
    cities['Chongqing'] = db.nodes(
      removed: false
      name: 'Chongqing'
      updatedAt: +new Date
      x: 295
      y: 1065).labels.set('City')
    cities['Chengdu'] = db.nodes(
      removed: false
      name: 'Chengdu'
      updatedAt: +new Date
      x: 305
      y: 1040).labels.set('City')
    cities['Chittagong'] = db.nodes(
      removed: false
      name: 'Chittagong'
      updatedAt: +new Date
      x: 223
      y: 918).labels.set('City')
    cities['Alexandria'] = db.nodes(
      removed: false
      name: 'Alexandria'
      updatedAt: +new Date
      x: 312
      y: 299).labels.set('City')
    cities['Tianjin'] = db.nodes(
      removed: false
      name: 'Tianjin'
      updatedAt: +new Date
      x: 390
      y: 1172).labels.set('City')
    cities['Melbourne'] = db.nodes(
      removed: false
      name: 'Melbourne'
      updatedAt: +new Date
      x: -378
      y: 1449).labels.set('City')
    cities['Ahmadabad'] = db.nodes(
      removed: false
      name: 'Ahmadabad'
      updatedAt: +new Date
      x: 230
      y: 725).labels.set('City')
    cities['Los Angeles'] = db.nodes(
      removed: false
      name: 'Los Angeles'
      updatedAt: +new Date
      x: 340
      y: -1182).labels.set('City')
    cities['Pusan'] = db.nodes(
      removed: false
      name: 'Pusan'
      updatedAt: +new Date
      x: 351
      y: 1290).labels.set('City')
    cities['Abidjan'] = db.nodes(
      removed: false
      name: 'Abidjan'
      updatedAt: +new Date
      x: 53
      y: -40).labels.set('City')
    cities['Kano'] = db.nodes(
      removed: false
      name: 'Kano'
      updatedAt: +new Date
      x: 120
      y: 85).labels.set('City')
    cities['Hyderabad'] = db.nodes(
      removed: false
      name: 'Hyderabad'
      updatedAt: +new Date
      x: 173
      y: 784).labels.set('City')
    cities['Yokohama'] = db.nodes(
      removed: false
      name: 'Yokohama'
      updatedAt: +new Date
      x: 354
      y: 1396).labels.set('City')
    cities['Ibadan'] = db.nodes(
      removed: false
      name: 'Ibadan'
      updatedAt: +new Date
      x: 73
      y: 39).labels.set('City')
    cities['Singapore'] = db.nodes(
      removed: false
      name: 'Singapore'
      updatedAt: +new Date
      x: 13
      y: 1038).labels.set('City')
    cities['Ankara'] = db.nodes(
      removed: false
      name: 'Ankara'
      updatedAt: +new Date
      x: 399
      y: 328).labels.set('City')
    cities['Shenyang'] = db.nodes(
      removed: false
      name: 'Shenyang'
      updatedAt: +new Date
      x: 418
      y: 1234).labels.set('City')
    cities['Ho Chi Minh City'] = db.nodes(
      removed: false
      name: 'Ho Chi Minh City'
      updatedAt: +new Date
      x: 108
      y: 1066).labels.set('City')
    cities['Shiyan'] = db.nodes(
      removed: false
      name: 'Shiyan'
      updatedAt: +new Date
      x: 326
      y: 1107).labels.set('City')
    cities['Cape Town'] = db.nodes(
      removed: false
      name: 'Cape Town'
      updatedAt: +new Date
      x: -339
      y: 184).labels.set('City')
    cities['Berlin'] = db.nodes(
      removed: false
      name: 'Berlin'
      updatedAt: +new Date
      x: 525
      y: 134).labels.set('City')
    cities['Montreal'] = db.nodes(
      removed: false
      name: 'Montreal'
      updatedAt: +new Date
      x: 455
      y: -735).labels.set('City')
    cities['Harbin'] = db.nodes(
      removed: false
      name: 'Harbin'
      updatedAt: +new Date
      x: 458
      y: 1265).labels.set('City')
    cities['Xi\'an'] = db.nodes(
      removed: false
      name: 'Xi\'an'
      updatedAt: +new Date
      x: 343
      y: 1089).labels.set('City')
    cities['Pyongyang'] = db.nodes(
      removed: false
      name: 'Pyongyang'
      updatedAt: +new Date
      x: 390
      y: 1257).labels.set('City')
    cities['Lanzhou'] = db.nodes(
      removed: false
      name: 'Lanzhou'
      updatedAt: +new Date
      x: 360
      y: 1038).labels.set('City')
    cities['Guangzhou'] = db.nodes(
      removed: false
      name: 'Guangzhou'
      updatedAt: +new Date
      x: 231
      y: 1132).labels.set('City')
    cities['Casablanca'] = db.nodes(
      removed: false
      name: 'Casablanca'
      updatedAt: +new Date
      x: 335
      y: -75).labels.set('City')
    cities['Durban'] = db.nodes(
      removed: false
      name: 'Durban'
      updatedAt: +new Date
      x: -298
      y: 310).labels.set('City')
    cities['Madrid'] = db.nodes(
      removed: false
      name: 'Madrid'
      updatedAt: +new Date
      x: 404
      y: -37).labels.set('City')
    cities['Nanjing'] = db.nodes(
      removed: false
      name: 'Nanjing'
      updatedAt: +new Date
      x: 320
      y: 1187).labels.set('City')
    cities['Kabul'] = db.nodes(
      removed: false
      name: 'Kabul'
      updatedAt: +new Date
      x: 345
      y: 692).labels.set('City')
    cities['Pune'] = db.nodes(
      removed: false
      name: 'Pune'
      updatedAt: +new Date
      x: 185
      y: 738).labels.set('City')
    cities['Surat'] = db.nodes(
      removed: false
      name: 'Surat'
      updatedAt: +new Date
      x: 211
      y: 728).labels.set('City')
    cities['Jiddah'] = db.nodes(
      removed: false
      name: 'Jiddah'
      updatedAt: +new Date
      x: 212
      y: 392).labels.set('City')
    cities['Chicago'] = db.nodes(
      removed: false
      name: 'Chicago'
      updatedAt: +new Date
      x: 418
      y: -876).labels.set('City')c
    ities['Kanpur'] = db.nodes(
      removed: false
      name: 'Kanpur'
      updatedAt: +new Date
      x: 264
      y: 803).labels.set('City')
    cities['Luanda'] = db.nodes(
      removed: false
      name: 'Luanda'
      updatedAt: +new Date
      x: -88
      y: 132).labels.set('City')
    cities['Addis Ababa'] = db.nodes(
      removed: false
      name: 'Addis Ababa'
      updatedAt: +new Date
      x: 89
      y: 387).labels.set('City')
    cities['Nairobi'] = db.nodes(
      removed: false
      name: 'Nairobi'
      updatedAt: +new Date
      x: -12
      y: 368).labels.set('City')
    cities['Taiyuan'] = db.nodes(
      removed: false
      name: 'Taiyuan'
      updatedAt: +new Date
      x: 378
      y: 1125).labels.set('City')
    cities['Salvador'] = db.nodes(
      removed: false
      name: 'Salvador'
      updatedAt: +new Date
      x: 137
      y: -888).labels.set('City')
    cities['Jaipur'] = db.nodes(
      removed: false
      name: 'Jaipur'
      updatedAt: +new Date
      x: 269
      y: 757).labels.set('City')
    cities['Dar es Salaam'] = db.nodes(
      removed: false
      name: 'Dar es Salaam'
      updatedAt: +new Date
      x: -67
      y: 392).labels.set('City')
    cities['Yunfu'] = db.nodes(
      removed: false
      name: 'Yunfu'
      updatedAt: +new Date
      x: 229
      y: 1120).labels.set('City')
    cities['Al Basrah'] = db.nodes(
      removed: false
      name: 'Al Basrah'
      updatedAt: +new Date
      x: 305
      y: 477).labels.set('City')
    cities['Osaka'] = db.nodes(
      removed: false
      name: 'Osaka'
      updatedAt: +new Date
      x: 346
      y: 1355).labels.set('City')
    cities['Mogadishu'] = db.nodes(
      removed: false
      name: 'Mogadishu'
      updatedAt: +new Date
      x: 20
      y: 453).labels.set('City')
    cities['Taegu'] = db.nodes(
      removed: false
      name: 'Taegu'
      updatedAt: +new Date
      x: 358
      y: 1286).labels.set('City')
    cities['Rome'] = db.nodes(
      removed: false
      name: 'Rome'
      updatedAt: +new Date
      x: 419
      y: 124).labels.set('City')
    cities['Changchun'] = db.nodes(
      removed: false
      name: 'Changchun'
      updatedAt: +new Date
      x: 438
      y: 1253).labels.set('City')
    cities['Kiev'] = db.nodes(
      removed: false
      name: 'Kiev'
      updatedAt: +new Date
      x: 504
      y: 305).labels.set('City')
    cities['Faisalabad'] = db.nodes(
      removed: false
      name: 'Faisalabad'
      updatedAt: +new Date
      x: 314
      y: 730).labels.set('City')
    cities['Izmir'] = db.nodes(
      removed: false
      name: 'Izmir'
      updatedAt: +new Date
      x: 384
      y: 271).labels.set('City')
    cities['Dakar'] = db.nodes(
      removed: false
      name: 'Dakar'
      updatedAt: +new Date
      x: 147
      y: -173).labels.set('City')
    cities['Lucknow'] = db.nodes(
      removed: false
      name: 'Lucknow'
      updatedAt: +new Date
      x: 268
      y: 809).labels.set('City')




    # Add relationship between cities
    # At this example we set km
    cities['Athens'].to cities['Cape Town'], 'ROUTE', km: 8015.08, updatedAt: +new Date
    cities['Zürich'].to cities['Cape Town'], 'ROUTE', km: 1617.27, updatedAt: +new Date
    cities['Cape Town'].to cities['Tokyo'], 'ROUTE', km: 9505.67, updatedAt: +new Date
    cities['Zürich'].to cities['Athens'], 'ROUTE', km: 1617.27, updatedAt: +new Date
    cities['Athens'].to cities['Tokyo'], 'ROUTE', km: 9576.67, updatedAt: +new Date
    cities['Shanghai'].to cities['Buenos Aires'], 'ROUTE', km: 19641, updatedAt: +new Date
    cities['Bombay'].to cities['Karachi'], 'ROUTE', km: 885.21, updatedAt: +new Date
    cities['Istanbul Ili'].to cities['Mexico City'], 'ROUTE', km: 11424.68, updatedAt: +new Date
    cities['Istanbul'].to cities['Delhi'], 'ROUTE', km: 4550.94, updatedAt: +new Date
    cities['Manila'].to cities['Moskva'], 'ROUTE', km: 8256.56, updatedAt: +new Date
    cities['Dhaka'].to cities['Seoul'], 'ROUTE', km: 3793.03, updatedAt: +new Date
    cities['Sao Paulo'].to cities['Lagos'], 'ROUTE', km: 6371.17, updatedAt: +new Date
    cities['Ogoyo'].to cities['Jakarta'], 'ROUTE', km: 11551.28, updatedAt: +new Date
    cities['Tokyo'].to cities['New York City'], 'ROUTE', km: 10846.31, updatedAt: +new Date
    cities['Taipei'].to cities['Kinshasa'], 'ROUTE', km: 11842.61, updatedAt: +new Date
    cities['Lima'].to cities['Cairo'], 'ROUTE', km: 12423.94, updatedAt: +new Date
    cities['Beijing'].to cities['London'], 'ROUTE', km: 8137.3, updatedAt: +new Date
    cities['Tehran'].to cities['Nanchong'], 'ROUTE', km: 5045.86, updatedAt: +new Date
    cities['Bogota'].to cities['Hong Kong'], 'ROUTE', km: 16893.63, updatedAt: +new Date
    cities['Lahore'].to cities['Rio de Janeiro'], 'ROUTE', km: 13845.56, updatedAt: +new Date
    cities['Baghdad'].to cities['Tai\'an'], 'ROUTE', km: 6488.14, updatedAt: +new Date
    cities['Bangkok'].to cities['Bengalooru'], 'ROUTE', km: 2479.66, updatedAt: +new Date
    cities['Santiago'].to cities['Kaifeng'], 'ROUTE', km: 19529.08, updatedAt: +new Date
    cities['Calcutta'].to cities['Toronto'], 'ROUTE', km: 12540.82, updatedAt: +new Date
    cities['Rangoon'].to cities['Sydney'], 'ROUTE', km: 8104.57, updatedAt: +new Date
    cities['Madras'].to cities['Riyadh'], 'ROUTE', km: 3739.37, updatedAt: +new Date
    cities['Wuhan'].to cities['Saint Petersburg'], 'ROUTE', km: 6779.17, updatedAt: +new Date
    cities['Chongqing'].to cities['Chengdu'], 'ROUTE', km: 268.77, updatedAt: +new Date
    cities['Chittagong'].to cities['Alexandria'], 'ROUTE', km: 6148.64, updatedAt: +new Date
    cities['Tianjin'].to cities['Melbourne'], 'ROUTE', km: 9015.33, updatedAt: +new Date
    cities['Ahmadabad'].to cities['Los Angeles'], 'ROUTE', km: 13563.7, updatedAt: +new Date
    cities['Pusan'].to cities['Abidjan'], 'ROUTE', km: 13362.76, updatedAt: +new Date
    cities['Kano'].to cities['Hyderabad'], 'ROUTE', km: 7510, updatedAt: +new Date
    cities['Yokohama'].to cities['Ibadan'], 'ROUTE', km: 13373.17, updatedAt: +new Date
    cities['Singapore'].to cities['Ankara'], 'ROUTE', km: 8303.74, updatedAt: +new Date
    cities['Shenyang'].to cities['Ho Chi Minh City'], 'ROUTE', km: 3818.87, updatedAt: +new Date
    cities['Shiyan'].to cities['Cape Town'], 'ROUTE', km: 12148.24, updatedAt: +new Date
    cities['Berlin'].to cities['Montreal'], 'ROUTE', km: 6001.76, updatedAt: +new Date
    cities['Harbin'].to cities['Xi\'an'], 'ROUTE', km: 1969.62, updatedAt: +new Date
    cities['Pyongyang'].to cities['Lanzhou'], 'ROUTE', km: 1959.25, updatedAt: +new Date
    cities['Guangzhou'].to cities['Casablanca'], 'ROUTE', km: 11132.72, updatedAt: +new Date
    cities['Durban'].to cities['Madrid'], 'ROUTE', km: 8593.47, updatedAt: +new Date
    cities['Nanjing'].to cities['Kabul'], 'ROUTE', km: 4571.28, updatedAt: +new Date
    cities['Pune'].to cities['Surat'], 'ROUTE', km: 312.1, updatedAt: +new Date
    cities['Jiddah'].to cities['Chicago'], 'ROUTE', km: 11102.32, updatedAt: +new Date
    cities['Kanpur'].to cities['Luanda'], 'ROUTE', km: 8228.89, updatedAt: +new Date
    cities['Addis Ababa'].to cities['Nairobi'], 'ROUTE', km: 1165.93, updatedAt: +new Date
    cities['Taiyuan'].to cities['Salvador'], 'ROUTE', km: 16033.58, updatedAt: +new Date
    cities['Jaipur'].to cities['Dar es Salaam'], 'ROUTE', km: 5433.39, updatedAt: +new Date
    cities['Yunfu'].to cities['Al Basrah'], 'ROUTE', km: 6350.67, updatedAt: +new Date
    cities['Osaka'].to cities['Mogadishu'], 'ROUTE', km: 9888.56, updatedAt: +new Date
    cities['Taegu'].to cities['Rome'], 'ROUTE', km: 9202.89, updatedAt: +new Date
    cities['Changchun'].to cities['Kiev'], 'ROUTE', km: 6701.71, updatedAt: +new Date
    cities['Faisalabad'].to cities['Izmir'], 'ROUTE', km: 4215.63, updatedAt: +new Date
    cities['Dakar'].to cities['Lucknow'], 'ROUTE', km: 10076.56, updatedAt: +new Date






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
