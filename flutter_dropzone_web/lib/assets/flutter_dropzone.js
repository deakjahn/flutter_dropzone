if (typeof FlutterDropzone === 'undefined') {
class FlutterDropzone {
  constructor(container, onLoaded, onError, onHover, onDrop, onLeave) {
    this.onHover = onHover;
    this.onDrop = onDrop;
    this.onLeave = onLeave;
    this.dropMIME = null;
    this.dropOperation = 'copy';

    container.addEventListener('dragover', this.dragover_handler.bind(this));
    container.addEventListener('dragleave', this.dragleave_handler.bind(this));
    container.addEventListener('drop', this.drop_handler.bind(this));

    if (onLoaded != null) onLoaded();
  }

  dragover_handler(event) {
    event.preventDefault();
    event.dataTransfer.dropEffect = this.dropOperation;
    if (this.onHover != null) this.onHover(event);
  }

  dragleave_handler(event) {
    event.preventDefault();
    if (this.onLeave != null) this.onLeave(event);
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
  isCanvasKit: function() {
    return window.flutterCanvasKit != null;
  },

  setMIME: function(container, mime) {
    container.FlutterDropzone.setMIME(mime);
  },

  setOperation: function(container, operation) {
    container.FlutterDropzone.setOperation(operation);
  },

  setCursor: function(container, cursor) {
    container.style.cursor = cursor;
  },

  create: function(container, onLoaded, onError, onHover, onDrop, onLeave) {
    container.FlutterDropzone = new FlutterDropzone(container, onLoaded, onError, onHover, onDrop, onLeave);
  },
};

window.dispatchEvent(new Event('flutter_dropzone_web_ready'));
}