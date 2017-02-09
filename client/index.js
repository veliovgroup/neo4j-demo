const vis = require('vis');
let MainTemplate = {};
const ND = { color: '#333' };
const NS = { color: '#111' };
const ED = { color: '#333' };
const ES = { color: '#111' };

const VIS_OPTIONS = {
  autoResize: true,
  height: '100%',
  width: '100%',
  configure: {
    enabled: false
  },
  manipulation: {
    enabled: false
  },
  nodes: {
    physics: false,
    shape: 'circle',
    labelHighlightBold: false,
    color: {
      background: '#555',
      border: '#222',
      highlight: {
        background: '#333',
        border: '#000'
      },
      hover: {
        background: '#444',
        border: '#111'
      }
    },
    font: {
      color: '#fefefe',
      strokeWidth: 0
    }
  },
  edges: {
    width: 1,
    font: {
      strokeWidth: 2,
      color: ES.color,
      align: 'middle'
    },
    color: ED.color,
    selectionWidth: 1,
    labelHighlightBold: false
  },
  interaction: {
    hover: false,
    hoverConnectedEdges: false,
    navigationButtons: false,
    selectConnectedEdges: false
  },
  groups: {
    Airport: {
      color: {
        background: '#555',
        border: '#222',
        highlight: {
          background: '#333',
          border: '#000'
        },
        hover: {
          background: '#444',
          border: '#111'
        }
      },
      font: {
        color: '#fefefe',
        strokeWidth: 0
      }
    },
    Selected: {
      color: {
        background: '#bd362f',
        border: '#1d1a33',
        highlight: {
          background: '#bd362f',
          border: '#1d1a33'
        },
        hover: {
          background: '#bd362f',
          border: '#1d1a33'
        }
      },
      font: {
        color: '#fefefe',
        strokeWidth: 0
      }
    }
  }
};

const VIS_PREVIEW_OPTIONS = {
  height: '75px',
  physics: {
    enabled: false
  },
  interaction: {
    hover: false,
    selectable: false,
    dragNodes: false,
    dragView: false,
    zoomView: false
  }
};

const clearNetwork = (template) => {
  if (template.Network) {
    template.Network.destroy();
  }
  if (template.nodesDS) {
    template.nodesDS.clear();
  }
  if (template.edgesDS) {
    template.edgesDS.clear();
  }
};

const makeFakeRelation = (template, from, to, container) => {
  /*
  As vis.js uses global DataSet, and we unable to add nodes with same id
  We set temp ids for preview nodes
   */
  template.rid = Random.id();
  template.fromId = Random.id();
  const _from = _.clone(from);
  _from.id = template.fromId;
  _from.x = -250;
  _from.y = 0;
  template.toId = Random.id();
  const _to = _.clone(to);
  _to.id = template.toId;
  _to.x = 250;
  _to.y = 0;
  if (template.relationship) {
    template.relationship.from = template.fromId;
    template.relationship.to = template.toId;
    template.relationship.id = template.rid;
  } else {
    template.relationship = {
      from: template.fromId,
      to: template.toId,
      id: template.rid,
      label: '0km',
      group: 'ROUTE',
      arrows: 'to'
    };
  }
  template.edgesDS = new vis.DataSet([template.relationship]);
  template.nodesDS = new vis.DataSet([_from, _to]);
  template.Network = new vis.Network(container, {
    nodes: template.nodesDS,
    edges: template.edgesDS
  }, _.extend(VIS_OPTIONS, VIS_PREVIEW_OPTIONS));
};


/*
Create `nl2br` global helper on startup
 */

Meteor.startup(() => {
  Template.registerHelper('nl2br', (string) => {
    if (string && !_.isEmpty(string)) {
      return string.replace(/(?:\r\n|\r|\n)/g, '<br />');
    }
    return void 0;
  });
});


/*
Template.main
 */
Template.main.onCreated(function () {
  MainTemplate = this;
  this._nodes = {};
  this.nodesDS = [];
  this._edges = {};
  this.edgesDS = [];
  this.Network = null;
  this.showMenu = new ReactiveVar(false);
  this.nodeFrom = new ReactiveVar(false);
  this.nodeTo = new ReactiveVar(false);
  this.relationship = new ReactiveVar(false);
  this.resetNodes = (type) => {
    if (type == null) {
      type = false;
    }
    switch (type) {
    case false:
      if (this.nodeFrom.get() && this._nodes[this.nodeFrom.get().id]) {
        this.nodesDS.update({
          id: this.nodeFrom.get().id,
          group: 'Airport',
          color: {
            border: ND.color
          }
        });
      }
      if (this.nodeTo.get() && this._nodes[this.nodeTo.get().id]) {
        this.nodesDS.update({
          id: this.nodeTo.get().id,
          group: 'Airport',
          color: {
            border: ND.color
          }
        });
      }
      this.nodeFrom.set(false);
      this.nodeTo.set(false);
      break;
    case 'to':
      if (this.nodeTo.get() && this._nodes[this.nodeTo.get().id]) {
        this.nodesDS.update({
          id: this.nodeTo.get().id,
          group: 'Airport',
          color: {
            border: ND.color
          }
        });
      }
      this.nodeTo.set(false);
      break;
    case 'from':
      if (this.nodeFrom.get() && this._nodes[this.nodeFrom.get().id]) {
        this.nodesDS.update({
          id: this.nodeFrom.get().id,
          group: 'Airport',
          color: {
            border: ND.color
          }
        });
      }
      this.nodeFrom.set(false);
      break;
    case 'edge':
      if (this.relationship.get() && this._edges[this.relationship.get().id]) {
        this.edgesDS.update({
          id: this.relationship.get().id,
          label: this.relationship.get().km + 'km',
          width: 1,
          color: ED.color,
          font: {
            color: ES.color
          }
        });
      }
      this.relationship.set(false);
      break;
    case 'all':
      this.nodeTo.set(false);
      this.nodeFrom.set(false);
      this.relationship.set(false);
      this.nodesDS.update(this.nodesDS.getIds().map((id) => {
        return {
          id: id,
          group: 'Airport',
          color: {
            border: ND.color
          }
        };
      }));

      this.edgesDS.update(this.edgesDS.getIds().map((id) => {
        return {
          id: id,
          width: 1,
          color: ED.color,
          font: {
            color: ES.color
          }
        };
      }));
    }
  };
});

Template.main.helpers({
  nodeTo() {
    return Template.instance().nodeTo.get();
  },
  nodeFrom() {
    return Template.instance().nodeFrom.get();
  },
  showMenu() {
    return Template.instance().showMenu.get();
  },
  relationship() {
    return Template.instance().relationship.get();
  },
  hasSelection() {
    return !!(Template.instance().nodeFrom.get() || Template.instance().nodeTo.get() || Template.instance().relationship.get());
  },
  getNodeDegree(node) {
    let degree  = 0;
    const edges = Template.instance()._edges;
    for (let key in edges) {
      if (edges[key].from === node.id || edges[key].to === node.id) {
        ++degree;
      }
    }
    return degree;
  }
});

Template.main.events({
  'click #menu'(e, template) {
    e.preventDefault();
    template.showMenu.set(!template.showMenu.get());
    return false;
  },
  'click button#deleteNode'(e, template) {
    e.preventDefault();
    const _n = template.nodeFrom.get();
    if (_n) {
      e.currentTarget.textContent = 'Removing...';
      e.currentTarget.disabled = true;
      Meteor.call('deleteNode', _n.id, (error) => {
        if (error) {
          throw new Meteor.Error(error);
        } else {
          template.nodesDS.remove(_n.id);
          delete template._nodes[_n.id];
          template.resetNodes();
          template.resetNodes('edge');
        }
      });
    }
    return false;
  },
  'submit form#createNode'(e, template) {
    e.preventDefault();
    const form = {
      name: '' + e.target.name.value
    };
    if (form.name.length > 0) {
      template.$(e.currentTarget).find(':submit').text('Creating...').prop('disabled', true);
      Meteor.call('createNode', form, (error, node) => {
        if (error) {
          throw new Meteor.Error(error);
        } else {
          template.nodesDS.add(node);
          template._nodes[node.id] = node;
          template.$(e.currentTarget).find(':submit').text('Create Node').prop('disabled', false);
          $(e.currentTarget)[0].reset();
          MainTemplate.Network.fit([node.id], {
            animation: {
              duration: 2,
              easingFunction: 'easeInOutQuad'
            }
          });
        }
      });
    }
    return false;
  },
  'submit form#editNode'(e, template) {
    e.preventDefault();
    const _n = template.nodeFrom.get();
    const form = {
      name: '' + e.target.name.value,
      id: _n.id
    };
    if (form.name.length > 0 && _n.name !== form.name) {
      template.$(e.currentTarget).find(':submit').text('Saving...').prop('disabled', true);
      Meteor.call('updateNode', form, (error, node) => {
        if (error) {
          throw new Meteor.Error(error);
        } else {
          template.nodesDS.update(node);
          template._nodes[node.id] = node;
          template.$(e.currentTarget).find(':submit').text('Update Node').prop('disabled', false);
          $(e.currentTarget)[0].reset();
          template.resetNodes();
          template.resetNodes('edge');
        }
      });
    }
    return false;
  }
});

Template.main.onRendered(function () {
  const container = document.getElementById('graph');
  this.nodesDS = new vis.DataSet([]);
  this.edgesDS = new vis.DataSet([]);
  const data = {
    nodes: this.nodesDS,
    edges: this.edgesDS
  };
  this.Network = new vis.Network(container, data, VIS_OPTIONS);
  this.Network.addEventListener('click', (data) => {
    if (this.relationship.get()) {
      this.resetNodes('edge');
    }
    if (data != null && data.nodes != null && data.nodes[0] != null) {
      data.nodes[0] = parseInt(data.nodes[0]);
      if (!this.nodeFrom.get()) {
        this.nodesDS.update({
          id: data.nodes[0],
          group: 'Selected',
          color: {
            border: NS.color
          }
        });
        this.nodeFrom.set(this._nodes[data.nodes[0]]);
        this.showMenu.set(true);
      } else if (this.nodeFrom.get() && !this.nodeTo.get()) {
        if (this.nodeFrom.get().id !== data.nodes[0]) {
          this.nodesDS.update({
            id: data.nodes[0],
            group: 'Selected',
            color: {
              border: NS.color
            }
          });
          this.nodeTo.set(this._nodes[data.nodes[0]]);
          this.showMenu.set(true);
        }
      } else if (this.nodeFrom.get() && this.nodeTo.get()) {
        this.resetNodes();
        this.nodesDS.update({
          id: data.nodes[0],
          group: 'Selected'
        });
        this.nodeFrom.set(this._nodes[data.nodes[0]]);
        this.showMenu.set(true);
      }
    } else if (data != null && data.edges != null && data.edges[0] != null) {
      this.resetNodes();
      this.edgesDS.update({
        id: data.edges[0],
        color: {
          color: '#bd362f',
          highlight: '#bd362f',
          hover: '#bd362f'
        },
        font: {
          color: '#1d1a33'
        }
      });
      this.relationship.set(this._edges[data.edges[0]]);
      this.showMenu.set(true);
    } else if (!(data != null && data.nodes != null && data.nodes[0] != null) && !(data != null && data.edges != null && data.edges[0] != null)) {
      this.resetNodes('all');
      this.showMenu.set(false);
    }
  });

  this.Network.addEventListener('dragEnd', (data) => {
    if (data != null && data.nodes != null && data.nodes[0] != null) {
      Meteor.call('nodeReposition', data.nodes[0], this.Network.getPositions()[data.nodes[0]]);
    }
  });

  let lastTimestamp = 0;

  const fetchData = (cb) => {
    if (cb == null) {
      cb = null;
    }

    Meteor.call('graph', lastTimestamp, (error, result) => {
      const data = result.data;
      const ids = [];
      const lastTimestamp = result.updatedAt;

      if (error) {
        throw new Meteor.Error(error);
      } else {
        for (let i = 0; i < data.nodes.length; i++) {
          if (data.nodes[i].removed) {
            if (this._nodes != null && this._nodes[data.nodes[i].id] != null) {
              this.nodesDS.remove(data.nodes[i].id);
              delete this._nodes[data.nodes[i].id];
            }
          } else {
            if (this._nodes != null && this._nodes[data.nodes[i].id] != null) {
              if (!EJSON.equals(data.nodes[i], this._nodes[data.nodes[i].id])) {
                this.nodesDS.update(data.nodes[i]);
                if (this.nodeFrom.get() && this.nodeFrom.get().id === data.nodes[i].id) {
                  this.nodeFrom.set(data.nodes[i]);
                }
                if (this.nodeTo.get() && this.nodeTo.get().id === data.nodes[i].id) {
                  this.nodeTo.set(data.nodes[i]);
                }

                /*
                If user currently inspecting / editing relationship,
                which somehow includes one of updated nodes - we update inspector state
                 */
                const r = this.relationship.get();
                if (r && (r.from === data.nodes[i].id || r.to === data.nodes[i].id)) {
                  const _r = _.clone(this.relationship.get());
                  _r.updatedAt = lastTimestamp;
                  this.relationship.set(_r);
                }
              }
            } else {
              this.nodesDS.add([data.nodes[i]]);
            }
            this._nodes[data.nodes[i].id] = data.nodes[i];
            ids.push(data.nodes[i].id);
          }
        }

        for (let j = 0; j < data.edges.length; j++) {
          data.edges[j].label = data.edges[j].km + 'km';
          if (data.edges[j].removed) {
            if (this._edges != null && this._edges[data.edges[j].id] != null) {
              this.edgesDS.remove(data.edges[j].id);
              delete this._edges[data.edges[j].id];

              /*
              If user currently inspecting / editing relationship, which just was removed
              We close inspector
               */
              if (this.relationship.get() && this.relationship.get().id === data.edges[j].id) {
                this.relationship.set(null);
              }
            }
          } else {
            if (this._edges != null && this._edges[data.edges[j].id] != null) {
              if (!EJSON.equals(data.edges[j], this._edges[data.edges[j].id])) {
                this.edgesDS.update(data.edges[j]);

                /*
                If user currently inspecting / editing relationship, which just was updated
                We update inspector
                 */
                if (this.relationship.get() && this.relationship.get().id === data.edges[j].id) {
                  this.relationship.set(data.edges[j]);
                }
              }
            } else {
              this.edgesDS.add([data.edges[j]]);
            }
            this._edges[data.edges[j].id] = data.edges[j];
          }
        }
        if (cb) {
          cb(ids);
        }
      }

      /*
      Set up long-polling
       */
      Meteor.setTimeout(fetchData, 1500);
    });
  };

  fetchData(function (ids) {
    MainTemplate.Network.fit(ids, {
      animation: {
        duration: 5,
        easingFunction: 'easeInOutQuad'
      }
    });
  });
});


/*
Template.createRelationship
 */

Template.createRelationship.onRendered(function () {
  this.from = MainTemplate.nodeFrom.get();
  this.to = MainTemplate.nodeTo.get();
  makeFakeRelation(this, this.from, this.to, document.getElementById('createRelPreview'));
  MainTemplate.previewEdge = {
    id: Math.floor(Math.random() * 99998),
    from: this.from.id,
    to: this.to.id,
    arrows: 'to',
    dashes: true,
    label: '0km',
    group: 'ROUTE',
    width: 5,
    color: '#bd362f'
  };
  MainTemplate.edgesDS.add(MainTemplate.previewEdge);
});

Template.createRelationship.onDestroyed(function () {
  clearNetwork(this);
  MainTemplate.edgesDS.remove(MainTemplate.previewEdge.id);
  delete MainTemplate.previewEdge;
});

Template.createRelationship.events({
  'submit form#createRelationship'(e, template) {
    e.preventDefault();
    template.$(e.currentTarget).find(':submit').text('Creating...').prop('disabled', true);
    const form = {
      km: parseFloat(e.target.km.value),
      from: template.from.id,
      to: template.to.id
    };

    if (form.km > 0) {
      Meteor.call('createRelationship', form, (error, edge) => {
        if (error) {
          throw new Meteor.Error(error);
        } else {
          MainTemplate.edgesDS.add(edge);
          MainTemplate._edges[edge.id] = edge;
          template.$(e.currentTarget).find(':submit').text('Create Relationship').prop('disabled', false);
          $(e.currentTarget)[0].reset();
          MainTemplate.resetNodes();
          MainTemplate.resetNodes('edge');
          MainTemplate.showMenu.set(false);
        }
      });
    }
    return false;
  },
  'click #getPath'(e, template) {
    e.preventDefault();
    template.$(e.currentTarget).text('Calculating...').prop('disabled', true);
    Meteor.call('getPath', parseInt(template.from.id), parseInt(template.to.id), (error, data) => {
      if (error) {
        template.$(e.currentTarget).text('Calculate Shortest Path').prop('disabled', false);
      } else if (data === false) {
        template.$(e.currentTarget).text('No route between those Cities');
      } else {
        template.$(e.currentTarget).text('Calculated: ' + data.km + 'km and ' + data.edges.length + ' transfers');
        for (let i = 0; i < data.nodes.length; i++) {
          MainTemplate.nodesDS.update({
            id: data.nodes[i],
            group: 'Selected'
          });
        }

        for (let j = 0; j < data.edges.length; j++) {
          MainTemplate.edgesDS.update({
            id: data.edges[j],
            width: 10,
            color: {
              color: '#bd362f',
              highlight: '#bd362f',
              hover: '#bd362f'
            },
            font: {
              color: '#1d1a33'
            }
          });
        }
        MainTemplate.Network.fit(data.edges.concat(data.nodes), {
          animation: {
            duration: 2,
            easingFunction: 'easeInOutQuad'
          }
        });
        template.relationship.label = MainTemplate.previewEdge.label = data.km + 'km';
        template.edgesDS.update(template.relationship);
        MainTemplate.edgesDS.update(MainTemplate.previewEdge);
      }
    });
    return false;
  },
  'change input#km'(e, template) {
    template.relationship.label = MainTemplate.previewEdge.label = e.currentTarget.value + 'km';
    template.relationship.group = MainTemplate.previewEdge.group = 'ROUTE';
    template.edgesDS.update(template.relationship);
    MainTemplate.edgesDS.update(MainTemplate.previewEdge);
  }
});

/*
Template.updateRelationship
 */
Template.updateRelationship.onRendered(function () {
  this.autorun(() => {
    clearNetwork(this);
    if (MainTemplate.relationship.get()) {
      this.relationship = _.clone(MainTemplate.relationship.get());
      makeFakeRelation(this, MainTemplate._nodes[this.relationship.from], MainTemplate._nodes[this.relationship.to], document.getElementById('updateRelPreview'));
    }
  });
});

Template.updateRelationship.onDestroyed(function () {
  clearNetwork(this);
});

Template.updateRelationship.helpers({
  relationship() {
    return MainTemplate.relationship.get();
  }
});

Template.updateRelationship.events({
  'submit form#updateRelationship'(e, template) {
    e.preventDefault();
    const _r = MainTemplate.relationship.get();
    const id = _r.id;
    const form = {
      id: id,
      km: e.target.km.value,
      from: _r.from,
      to: _r.to
    };
    if (_r.km !== form.km) {
      template.$(e.currentTarget).find(':submit').text('Updating...').prop('disabled', true);
      Meteor.call('updateRelationship', form, function (error, edge) {
        if (error) {
          throw new Meteor.Error(error);
        } else if (_.isObject(edge)) {
          MainTemplate.edgesDS.update(edge);
          MainTemplate._edges[edge.id] = edge;
        }
        template.$(e.currentTarget).find(':submit').text('Update Relationship').prop('disabled', false);
        $(e.currentTarget)[0].reset();
        MainTemplate.resetNodes();
        MainTemplate.resetNodes('edge');
      });
    }
    return false;
  },
  'click button#deleteRelationship'(e) {
    e.preventDefault();
    e.currentTarget.textContent = 'Removing...';
    e.currentTarget.disabled = true;
    const id = MainTemplate.relationship.get().id;
    Meteor.call('deleteRelationship', id, (error) => {
      if (error) {
        throw new Meteor.Error(error);
      } else {
        MainTemplate.edgesDS.remove(id);
        delete MainTemplate._edges[id];
        MainTemplate.resetNodes();
        MainTemplate.resetNodes('edge');
      }
    });
    return false;
  },
  'change input#km'(e, template) {
    const edge = MainTemplate.relationship.get();
    edge.label = template.relationship.label = e.currentTarget.value + 'km';
    MainTemplate.edgesDS.update(edge);
    template.relationship.group = 'ROUTE';
    template.edgesDS.update(template.relationship);
  }
});
