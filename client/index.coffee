vis = require 'vis'

MainTemplate = {}

ND = color: '#333'
NS = color: '#111'
ED = color: '#333'
ES = color: '#111'

VIS_OPTIONS =
  autoResize: true
  height: '100%'
  width: '100%'
  configure: enabled: false
  manipulation: enabled: false
  nodes:
    physics: false
    shape: 'circle'
    labelHighlightBold: false
    color:
      background: '#555'
      border: '#222'
      highlight:
        background: '#333'
        border: '#000'
      hover:
        background: '#444'
        border: '#111'
    font:
      color: '#fefefe'
      strokeWidth: 0
  edges: 
    font: 
      strokeWidth: 2
      color: ES.color
      align: 'middle'
    color: ED.color
    selectionWidth: 1
    labelHighlightBold: false
  interaction:
    hover: false
    hoverConnectedEdges: false
    navigationButtons: false
    selectConnectedEdges: false
  physics: 
    stabilization: false
  groups:
    City:
      color:
        background: '#555'
        border: '#222'
        highlight:
          background: '#333'
          border: '#000'
        hover:
          background: '#444'
          border: '#111'
      font:
        color: '#fefefe'
        strokeWidth: 0
    Selected:
      color:
        background: '#433c76'
        border: '#1d1a33'
        highlight:
          background: '#433c76'
          border: '#1d1a33'
        hover:
          background: '#433c76'
          border: '#1d1a33'
      font:
        color: '#fefefe'
        strokeWidth: 0

VIS_PREVIEW_OPTIONS = 
  height: '75px'
  physics: enabled: false
  interaction:
    hover: false
    selectable: false
    dragNodes: false
    dragView: false
    zoomView: false


clearNetwork = (template) ->
  template.Network.destroy() if template.Network
  template.nodesDS.clear() if template.nodesDS
  template.edgesDS.clear() if template.edgesDS
  return

makeFakeRelation = (template, from, to, container) ->
  ###
  As vis.js uses global DataSet, and we unable to add nodes with same id
  We set temp ids for preview nodes
  ###
  template.rid = Random.id()
  template.fromId = Random.id()
  _from = _.clone from
  _from.id = template.fromId
  _from.x = -150
  _from.y = 0

  template.toId = Random.id()
  _to = _.clone to
  _to.id = template.toId
  _to.x = 150
  _to.y = 0

  if template.relationship
    template.relationship.from = template.fromId
    template.relationship.to = template.toId
    template.relationship.id = template.rid
  else
    template.relationship = 
      from: template.fromId
      to: template.toId
      id: template.rid
      label: '0km'
      group: 'ROUTE'
      arrows: 'to'

  template.edgesDS = new vis.DataSet [template.relationship]
  template.nodesDS = new vis.DataSet [_from, _to]

  data = {nodes: template.nodesDS, edges: template.edgesDS}
  template.Network = new vis.Network container, data, _.extend VIS_OPTIONS, VIS_PREVIEW_OPTIONS
  return

###
Create `nl2br` global helper on startup
###
Meteor.startup ->
  Template.registerHelper 'nl2br', (string) ->
    if string and not _.isEmpty string
      string.replace /(?:\r\n|\r|\n)/g, '<br />'
    else
      undefined
  return

###
Template.main
###
Template.main.onCreated ->
  MainTemplate = @
  @_nodes = {}
  @nodesDS = []
  @_edges = {}
  @edgesDS = []
  @Network = null
  @showMenu = new ReactiveVar false
  @nodeFrom = new ReactiveVar false
  @nodeTo = new ReactiveVar false
  @relationship = new ReactiveVar false
  @resetNodes = (type = false) =>
    switch type
      when false
        @nodesDS.update {id: @nodeFrom.get().id, group: 'City', color: border: ND.color} if @nodeFrom.get() and @_nodes[@nodeFrom.get().id]
        @nodesDS.update {id: @nodeTo.get().id, group: 'City', color: border: ND.color} if @nodeTo.get() and @_nodes[@nodeTo.get().id]
        @nodeFrom.set false
        @nodeTo.set false
      when 'to'
        @nodesDS.update {id:@nodeTo.get().id, group: 'City', color: border: ND.color} if @nodeTo.get() and @_nodes[@nodeTo.get().id]
        @nodeTo.set false
      when 'from'
        @nodesDS.update {id:@nodeFrom.get().id, group: 'City', color: border: ND.color} if @nodeFrom.get() and @_nodes[@nodeFrom.get().id]
        @nodeFrom.set false
      when 'edge'
        @edgesDS.update {id: @relationship.get().id, label: @relationship.get().km + 'km', color: ED.color, font: color: ES.color} if @relationship.get() and @_edges[@relationship.get().id]
        @relationship.set false
      when 'all'
        @nodeTo.set false
        @nodeFrom.set false
        @relationship.set false
        @nodesDS.update ({id, group: 'City', color: border: ND.color} for id in @nodesDS.getIds())
        @edgesDS.update ({id, color: ED.color, font: color: ES.color} for id in @edgesDS.getIds())
    return
  return


Template.main.helpers
  nodeTo:       -> Template.instance().nodeTo.get()
  nodeFrom:     -> Template.instance().nodeFrom.get()
  showMenu:     -> Template.instance().showMenu.get()
  relationship: -> Template.instance().relationship.get()
  hasSelection: -> !!(Template.instance().nodeFrom.get() or Template.instance().nodeTo.get() or Template.instance().relationship.get())
  getNodeDegree: (node) -> 
    degree = 0
    for key, e of Template.instance()._edges
      if e.from is node.id or e.to is node.id
        ++degree
    degree

Template.main.events
  'click #menu': (e, template) ->
    e.preventDefault()
    template.showMenu.set !template.showMenu.get()
    false
  'click button#deleteNode': (e, template) ->
    e.preventDefault()
    _n = template.nodeFrom.get()
    if _n
      e.currentTarget.textContent = 'Removing...'
      e.currentTarget.disabled = true
      Meteor.call 'deleteNode', _n.id, (error) ->
        if error
          throw new Meteor.Error error
        else
          template.nodesDS.remove _n.id
          delete template._nodes[_n.id]
          template.resetNodes()
          template.resetNodes 'edge'
        return
    false

  'submit form#createNode': (e, template) ->
    e.preventDefault()
    form = name: "#{e.target.name.value}"

    if form.name.length > 0
      template.$(e.currentTarget).find(':submit').text('Creating...').prop('disabled', true)
      Meteor.call 'createNode', form, (error, node) ->
        if error
          throw new Meteor.Error error
        else
          template.nodesDS.add node
          template._nodes[node.id] = node
          template.$(e.currentTarget).find(':submit').text('Create Node').prop('disabled', false)
          $(e.currentTarget)[0].reset()
        return
    false

  'submit form#editNode': (e, template) ->
    e.preventDefault()
    _n = template.nodeFrom.get()
    form = 
      name: "#{e.target.name.value}"
      id: _n.id

    if form.name.length > 0 and _n.name isnt form.name
      template.$(e.currentTarget).find(':submit').text('Saving...').prop('disabled', true)
      Meteor.call 'updateNode', form, (error, node) ->
        if error
          throw new Meteor.Error error
        else
          template.nodesDS.update node
          template._nodes[node.id] = node
          template.$(e.currentTarget).find(':submit').text('Update Node').prop('disabled', false)
          $(e.currentTarget)[0].reset()
          template.resetNodes()
          template.resetNodes('edge')
        return
    false

Template.main.onRendered ->
  container = document.getElementById 'graph'
  @nodesDS = new vis.DataSet []
  @edgesDS = new vis.DataSet []
  data = {nodes: @nodesDS, edges: @edgesDS}

  @Network = new vis.Network container, data, VIS_OPTIONS

  @Network.addEventListener 'click', (data) =>
    if @relationship.get()
      @resetNodes 'edge'

    if data?.nodes?[0]
      data.nodes[0] = parseInt data.nodes[0]
      unless @nodeFrom.get()
        @nodesDS.update {id: data.nodes[0], group: 'Selected', color: border: NS.color}
        @nodeFrom.set @_nodes[data.nodes[0]]
        @showMenu.set true

      else if @nodeFrom.get() and not @nodeTo.get()
        unless @nodeFrom.get().id is data.nodes[0]
          @nodesDS.update {id: data.nodes[0], group: 'Selected', color: border: NS.color}
          @nodeTo.set @_nodes[data.nodes[0]]
          @showMenu.set true

      else if @nodeFrom.get() and @nodeTo.get()
        @resetNodes()
        @nodesDS.update {id: data.nodes[0], group: 'Selected'}
        @nodeFrom.set @_nodes[data.nodes[0]]
        @showMenu.set true

    else if data?.edges?[0]
      @resetNodes()

      @edgesDS.update {id: data.edges[0], color: {color:'#433c76', highlight:'#433c76', hover: '#433c76'}, font: color: '#1d1a33'}
      @relationship.set @_edges[data.edges[0]]
      @showMenu.set true

    else if not data?.nodes?[0] and not data?.edges?[0]
      @resetNodes('all')
      @showMenu.set false
    return

  @Network.addEventListener 'dragEnd', (data) =>
    Meteor.call 'nodeReposition', data.nodes[0], @Network.getPositions()[data.nodes[0]] if data?.nodes?[0]
    return


  lastTimestamp = 0
  fetchData = =>
    Meteor.call 'graph', lastTimestamp, (error, result) =>
      data = result.data
      lastTimestamp = result.updatedAt
      if error
        throw new Meteor.Error error
      else
        for node in data.nodes
          if node.removed
            if @_nodes?[node.id]
              @nodesDS.remove node.id
              delete @_nodes[node.id]
          else
            if @_nodes?[node.id]
              unless EJSON.equals node, @_nodes[node.id]
                @nodesDS.update node
                @nodeFrom.set node if @nodeFrom.get() and @nodeFrom.get().id is node.id
                @nodeTo.set node if @nodeTo.get() and @nodeTo.get().id is node.id
                ###
                If user currently inspecting / editing relationship, 
                which somehow includes one of updated nodes - we update inspector state
                ###
                r = @relationship.get()
                if r and (r.from is node.id or r.to is node.id)
                  _r = _.clone @relationship.get()
                  _r.updatedAt = lastTimestamp
                  @relationship.set _r
            else
              @nodesDS.add [node]
            @_nodes[node.id] = node

        for edge in data.edges
          edge.label = edge.km + 'km'
          if edge.removed
            if @_edges?[edge.id]
              @edgesDS.remove edge.id
              delete @_edges[edge.id]
              ###
              If user currently inspecting / editing relationship, which just was removed
              We close inspector
              ###
              @relationship.set null if @relationship.get() and @relationship.get().id is edge.id
          else
            if @_edges?[edge.id]
              unless EJSON.equals edge, @_edges[edge.id]
                @edgesDS.update edge
                ###
                If user currently inspecting / editing relationship, which just was updated
                We update inspector
                ###
                @relationship.set edge if @relationship.get() and @relationship.get().id is edge.id
            else
              @edgesDS.add [edge]
            @_edges[edge.id] = edge

      ###
      Set up long-polling
      ###
      Meteor.setTimeout fetchData, 1500
      return
    return

  fetchData()
  return


###
Template.createRelationship
###
Template.createRelationship.onRendered ->
  @from = MainTemplate.nodeFrom.get()
  @to = MainTemplate.nodeTo.get()
  makeFakeRelation @, @from, @to, document.getElementById 'createRelPreview'
  MainTemplate.previewEdge = 
    id: Math.floor(Math.random() * 99998)
    from: @from.id
    to: @to.id
    arrows: 'to'
    dashes: true
    label: '0km'
    group: 'ROUTE'

  MainTemplate.edgesDS.add MainTemplate.previewEdge
  return


Template.createRelationship.onDestroyed -> 
  clearNetwork @
  MainTemplate.edgesDS.remove MainTemplate.previewEdge.id
  delete MainTemplate.previewEdge
  return

Template.createRelationship.events
  'submit form#createRelationship': (e, template) ->
    e.preventDefault()
    template.$(e.currentTarget).find(':submit').text('Creating...').prop('disabled', true)
    form = 
      km: parseFloat e.target.km.value
      from: template.from.id
      to: template.to.id

    if form.km > 0
      Meteor.call 'createRelationship', form, (error, edge) ->
        if error
          throw new Meteor.Error error
        else
          MainTemplate.edgesDS.add edge
          MainTemplate._edges[edge.id] = edge
          template.$(e.currentTarget).find(':submit').text('Create Relationship').prop('disabled', false)
          $(e.currentTarget)[0].reset()
          MainTemplate.resetNodes()
          MainTemplate.resetNodes('edge')
          MainTemplate.showMenu.set false
        return
    false

  'click #getPath': (e, template) ->
    e.preventDefault()
    template.$(e.currentTarget).text('Calculating...').prop 'disabled', true

    Meteor.call 'getPath', parseInt(template.from.id), parseInt(template.to.id), (error, data) ->
      if error
        template.$(e.currentTarget).text('Calculate Shortest Path').prop('disabled', false)
      else if data is false
        template.$(e.currentTarget).text('No route between those Cities')
      else
        template.$(e.currentTarget).text('Calculated: ' + data.km + 'km and ' + data.edges.length + ' transfers')
        for id in data.nodes
          MainTemplate.nodesDS.update {id: id, group: 'Selected'}
        
        for id in data.edges
          MainTemplate.edgesDS.update {id: id, color: {color:'#433c76', highlight:'#433c76', hover: '#433c76'}, font: color: '#1d1a33'}

        MainTemplate.Network.fit data.edges.concat(data.nodes), {animation: 2, easingFunction: 'easeInOutQuad'}

        template.relationship.label = MainTemplate.previewEdge.label = data.km + 'km'
        template.edgesDS.update template.relationship
        MainTemplate.edgesDS.update MainTemplate.previewEdge
      return
    return false

  'change input#km': (e, template) ->
    template.relationship.label = MainTemplate.previewEdge.label = e.currentTarget.value + 'km'
    template.relationship.group = MainTemplate.previewEdge.group = 'ROUTE'
    template.edgesDS.update template.relationship
    MainTemplate.edgesDS.update MainTemplate.previewEdge
    return

###
Template.updateRelationship
###
Template.updateRelationship.onRendered ->
  @autorun =>
    clearNetwork @
    if MainTemplate.relationship.get()
      @relationship = _.clone MainTemplate.relationship.get()
      makeFakeRelation @, MainTemplate._nodes[@relationship.from], MainTemplate._nodes[@relationship.to], document.getElementById 'updateRelPreview'
    return

Template.updateRelationship.onDestroyed ->
  clearNetwork @
  return

Template.updateRelationship.helpers
  relationship: -> MainTemplate.relationship.get()

Template.updateRelationship.events
  'submit form#updateRelationship': (e, template) ->
    e.preventDefault()
    _r = MainTemplate.relationship.get()
    id = _r.id
    form = 
      id: id
      km: e.target.km.value
      from: _r.from
      to: _r.to

    if _r.km isnt form.km
      template.$(e.currentTarget).find(':submit').text('Updating...').prop('disabled', true)
      Meteor.call 'updateRelationship', form, (error, edge) ->
        if error
          throw new Meteor.Error error
        else if _.isObject edge
          # if _r.type isnt form.type
          #   # As in Neo4j no way to change relationship `type`
          #   # We will create new one and replace it
          #   MainTemplate.edgesDS.remove id
          #   delete MainTemplate._edges[id]
          #   MainTemplate.edgesDS.add edge
          # else
          MainTemplate.edgesDS.update edge
          MainTemplate._edges[edge.id] = edge

        template.$(e.currentTarget).find(':submit').text('Update Relationship').prop('disabled', false)
        $(e.currentTarget)[0].reset()
        MainTemplate.resetNodes()
        MainTemplate.resetNodes('edge')
        return
    false

  'click button#deleteRelationship': (e, template) ->
    e.preventDefault()
    e.currentTarget.textContent = 'Removing...'
    e.currentTarget.disabled = true
    id = MainTemplate.relationship.get().id
    Meteor.call 'deleteRelationship', id, (error, edge) ->
      if error
        throw new Meteor.Error error
      else
        MainTemplate.edgesDS.remove id
        delete MainTemplate._edges[id]
        MainTemplate.resetNodes()
        MainTemplate.resetNodes('edge')
      return
    false

  'change input#km': (e, template) ->
    edge = MainTemplate.relationship.get()
    edge.label = template.relationship.label = e.currentTarget.value + 'km'
    MainTemplate.edgesDS.update edge
    template.relationship.group = 'ROUTE'
    template.edgesDS.update template.relationship
    return