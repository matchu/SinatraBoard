(function () {
  function Pane(id, data) {
    this.id = id;
    this.title = data.title;
    this.link = data.link;
    this.stats = data.stats;
  }

  var paneCollection = new function PaneCollection() {
    this.panes = {};

    this.loadAll = function () {
      $.get('/panes.json', function (data) {
        for(var id in data) {
          paneCollection.panes[id] = new Pane(id, data[id]);
        }
        statboard.update();
      });
    }
  }

  var statboard = new function Statboard() {
    $.template('pane', document.getElementById('pane-template'));
    var ul = $('#data'), loading = $('#loading');

    this.update = function () {
      if(loading) {
        loading.remove();
        loading = null;
      }
      for(var id in paneCollection.panes) {
        liFor(id).html(
          $.tmpl('pane', paneCollection.panes[id])
        );
      }
    }

    function liFor(id) {
      var fullId = 'pane-' + id, li = $('#' + fullId);
      if(!li.length) {
        li = $('<li/>', {'class': 'pane', 'id': fullId}).appendTo(ul);
      }
      return li;
    }
  }

  paneCollection.loadAll();
  setInterval($.proxy(paneCollection, 'loadAll'), STATBOARD_CONFIG.reload_every * 1000);
})();

