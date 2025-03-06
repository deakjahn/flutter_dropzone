if (typeof FlutterDropzone === 'undefined') {
class FlutterDropzone {
  constructor(container, onLoaded, onError, onHover, onDrop, onDropFile, onDropString, onDropInvalid, onDropMultiple, onDropFiles, onDropStrings, onLeave) {
    this.onError = onError;
    this.onHover = onHover;
    this.onDrop = onDrop;
    this.onDropFile = onDropFile;
    this.onDropString = onDropString;
    this.onDropInvalid = onDropInvalid;
    this.onDropMultiple = onDropMultiple;
    this.onDropFiles = onDropFiles;
    this.onDropStrings = onDropStrings;
    this.onLeave = onLeave;
    this.dropMIME = null;
    this.dropOperation = 'copy';

    container.addEventListener('dragover', this.dragover_handler.bind(this));
    container.addEventListener('dragleave', this.dragleave_handler.bind(this));
    container.addEventListener('drop', this.drop_handler.bind(this));

    if (onLoaded != null) onLoaded();
  }

  updateHandlers(onLoaded, onError, onHover, onDrop, onDropFile, onDropString, onDropInvalid, onDropMultiple, onDropFiles, onDropStrings, onLeave) {
    this.onError = onError;
    this.onHover = onHover;
    this.onDrop = onDrop;
    this.onDropFile = onDropFile;
    this.onDropString = onDropString;
    this.onDropMultiple = onDropMultiple;
    this.onDropFiles = onDropFiles;
    this.onDropStrings = onDropStrings;
    this.onDropInvalid = onDropInvalid;
    this.onLeave = onLeave;
    this.dropMIME = null;
    this.dropOperation = 'copy';
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

  async drop_handler(event) {
    event.preventDefault();

    var files = [];
    var strings = [];
    if (event.dataTransfer.items) {
      for (let i = 0; i < event.dataTransfer.items.length; i++) {
        const item = event.dataTransfer.items[i];
        switch (item.kind) {
          case "file":
            if (this.dropMIME == null || this.dropMIME.includes(item.type)) {
              const file = item.getAsFile();
              if (this.onDrop != null) this.onDrop(event, file);
              if (this.onDropFile != null) this.onDropFile(event, file);
              files.push(file);
            }
            else {
              if (this.onDropInvalid != null) this.onDropInvalid(event, item.type);
            }
            break;

          case "string":
            const that = this;
            const text = await this.#getItemAsString(item);
            // if (that.onDrop != null) that.onDrop(event, text);
            if (that.onDropString != null) that.onDropString(event, text);
            strings.push(text);
            break;

          default:
            if (this.onError != null) this.onError("Wrong type: ${item.kind}");
            break;
        }
      }
    } else {
      throw new Error("Shouldn't happen. Please, report if you ever encounter this.");
//      for (let i = 0; i < event.dataTransfer.files.length; i++) {
//        const file = event.dataTransfer.files[i];
//        if (this.onDrop != null) this.onDrop(event, file);
//        if (this.onDropFile != null) this.onDropFile(event, file);
//        files.push(file);
//      }
    }

    if (this.onDropMultiple != null) {
      if (files.length > 0) this.onDropMultiple(event, files);
      // if (strings.length > 0) this.onDropMultiple(event, strings);
    }

    if (this.onDropFiles != null && files.length > 0) this.onDropFiles(event, files);
    if (this.onDropStrings != null && strings.length > 0) this.onDropStrings(event,strings);
  }

  #getItemAsString(item) {
    return new Promise((resolve, reject) => {
      item.getAsString(function (text) {
        resolve(text);
      });
    })
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
    return true;
  },

  setOperation: function(container, operation) {
    container.FlutterDropzone.setOperation(operation);
    return true;
  },

  setCursor: function(container, cursor) {
    container.style.cursor = cursor;
    return true;
  },

  create: function(container, onLoaded, onError, onHover, onDrop, onDropFile, onDropString, onDropInvalid, onDropMultiple, onDropFiles, onDropStrings, onLeave) {
    if (container.FlutterDropzone === undefined)
      container.FlutterDropzone = new FlutterDropzone(container, onLoaded, onError, onHover, onDrop, onDropFile, onDropString, onDropInvalid, onDropMultiple, onDropFiles, onDropStrings, onLeave);
    else
      container.FlutterDropzone.updateHandlers(onLoaded, onError, onHover, onDrop, onDropFile, onDropString, onDropInvalid, onDropMultiple, onDropFiles, onDropStrings, onLeave);
  },
};

window.dispatchEvent(new Event('flutter_dropzone_web_ready'));
}