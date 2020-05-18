var flutter_dropzone_web = {
  onDrop: null,
  dropMIME: null,
  dropOperation: 'copy',

  initialize: function(container, onLoaded, onError, onDrop) {
    var $ = flutter_dropzone_web;
    container.addEventListener('dragover', $.dragover_handler);
    $.onDrop = onDrop;
    container.addEventListener('drop', $.drop_handler);

    onLoaded();
  },

  dragover_handler: function(event) {
    var $ = flutter_dropzone_web;
    event.preventDefault();
    event.dataTransfer.dropEffect = $.dropOperation;
  },

  drop_handler: function(event) {
    var $ = flutter_dropzone_web;
    event.preventDefault();

    if (event.dataTransfer.items) {
      for (var i = 0; i < event.dataTransfer.items.length; i++) {
        var item = event.dataTransfer.items[i];
        var match = (item.kind === 'file');
        if ($.dropMIME != null && !$.dropMIME.includes(item.mime))
          match = false;

        if (match) {
          var file = event.dataTransfer.items[i].getAsFile();
          $.onDrop(event, file.name);
        }
      }
    } else {
      for (var i = 0; i < ev.dataTransfer.files.length; i++)
        $.onDrop(event, event.dataTransfer.files[i].name);
    }
  },

  setMIME: function(container, mime) {
    flutter_dropzone_web.dropMIME = mime;
  },

  setOperation: function(container, operation) {
    flutter_dropzone_web.dropOperation = operation;
  },

  triggerBuild: function(id) {
    for (const view of document.getElementsByTagName('flt-platform-view')) {
      var item = view.shadowRoot.getElementById('dropzone-container-' + id);
      if (item != null)
        item.dispatchEvent(new Event('build'))
    }
  },
};

window.dispatchEvent(new Event('flutter_dropzone_web_ready'));