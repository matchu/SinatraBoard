(function () {
  // Define a Pane object. May seem a bit redundant, since the AJAX data
  // already formats panes almost exactly like this, but this includes the id
  // attribute and also allows us to possibly extend the object in the future.
  function Pane(id, data) {
    this.id = id;
    this.title = data.title;
    this.link = data.link;
    this.stats = data.stats;
  }

  // The paneCollection object contains both the list of panes itself and a
  // function to load all of them at once.
  var paneCollection = new function PaneCollection() {
    this.panes = {};

    // Fetch the pane data via AJAX, turn each of the returned elements into a
    // Pane object, then tell the statboard that we're ready for it to update.
    this.loadAll = function () {
      $.get('/panes.json', function (data) {
        for(var id in data) {
          paneCollection.panes[id] = new Pane(id, data[id]);
        }
        statboard.update();
      });
    }
  }

  // This is the Statboard display itself. It is kept totally separate from the
  // definition of a Pane and PaneCollection since mixing AJAX, stated
  // collections, and DOM makes for serious headaches.
  var statboard = new function Statboard() {
    var ul = $('#data'), loading = $('#loading'), lis = {};

    // Compile our pane template (using the jQuery Templates plugin) for future use
    $.template('pane', document.getElementById('pane-template'));

    this.update = function () {
      if(loading) { // If the loading element still exists, get rid of it
        loading.remove();
        loading = null;
      }
      for(var id in paneCollection.panes) {
        // Find the li for this pane, and update its contents with the
        // pane template's result
        liFor(id).html(
          $.tmpl('pane', paneCollection.panes[id])
        );
      }
    }

    // Finds the li for a given pane, or creates it if it doesn't exist
    function liFor(id) {
      if(!lis.hasOwnProperty(id)) {
        lis[id] = $('<li/>', {'class': 'pane ' + id}).appendTo(ul);
      }
      return lis[id];
    }
  }

  // Now that everything's set up, load up the panes
  paneCollection.loadAll();

  // Then run loadAll again every N seconds, where N is the reload_every config
  // set in the HTML document.

  // $.proxy is a jQuery helper that ensures that, when the loadAll function
  // runs, it runs within the context of the original PaneCollection, rather
  // than the window. Otherwise, a call to "this" that's clearly meant to refer
  // to the PaneCollection would refer to the window, which would be messy.
  setInterval($.proxy(paneCollection, 'loadAll'), STATBOARD_CONFIG.reload_every * 1000);
})();

