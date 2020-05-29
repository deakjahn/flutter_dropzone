class FlutterDropzone {
  constructor(container, onLoaded, onError, onDrop) {
    this.onDrop = onDrop;
    this.dropMIME = null;
    this.dropOperation = 'copy';

    container.addEventListener('dragover', this.dragover_handler.bind(this));
    container.addEventListener('drop', this.drop_handler.bind(this));

    if (onLoaded != null) onLoaded();
  }

  dragover_handler(event) {
    event.preventDefault();
    event.dataTransfer.dropEffect = this.dropOperation;
  }

  drop_handler(event) {
    event.preventDefault();

    if (event.dataTransfer.items) {
      for (var i = 0; i < event.dataTransfer.items.length; i++) {
        var item = event.dataTransfer.items[i];
        var match = (item.kind === 'file');
        if (this.dropMIME != null && !this.dropMIME.includes(item.mime))
          match = false;

        if (match) {
          var file = event.dataTransfer.items[i].getAsFile();
          this.onDrop(event, file);
        }
      }
    } else {
      for (var i = 0; i < ev.dataTransfer.files.length; i++)
        this.onDrop(event, event.dataTransfer.files[i]);
    }
  }

  setMIME(mime) {
    this.dropMIME = mime;
  }

  setOperation(operation) {
    this.dropOperation = operation;
  }
}

var flutter_dropzone_web = {
  setMIME: function(container, mime) {
    container.FlutterDropzone.setMIME(mime);
  },

  setOperation: function(container, operation) {
    container.FlutterDropzone.setOperation(operation);
  },

  triggerBuild: function(id) {
    for (var view of document.getElementsByTagName('flt-platform-view')) {
      var item = view.shadowRoot.getElementById('dropzone-container-' + id);
      if (item != null)
        item.dispatchEvent(new Event('build'))
    }
  },

  create: function(container, onLoaded, onError, onDrop) {
    container.FlutterDropzone = new FlutterDropzone(container, onLoaded, onError, onDrop);
  },
};

window.dispatchEvent(new Event('flutter_dropzone_web_ready'));