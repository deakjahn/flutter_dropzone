if (typeof FlutterDropzone === "undefined") {
  class FlutterDropzone {
    constructor(
      container,
      onLoaded,
      onError,
      onHover,
      onDrop,
      onDropMultiple,
      onLeave
    ) {
      this.onError = onError;
      this.onHover = onHover;
      this.onDrop = onDrop;
      this.onDropMultiple = onDropMultiple;
      this.onLeave = onLeave;
      this.dropMIME = null;
      this.dropOperation = "copy";

      container.addEventListener("dragover", this.dragover_handler.bind(this));
      container.addEventListener(
        "dragleave",
        this.dragleave_handler.bind(this)
      );
      container.addEventListener("drop", this.drop_handler.bind(this));

      if (onLoaded) {
        onLoaded();
      }
    }

    updateHandlers(
      onLoaded,
      onError,
      onHover,
      onDrop,
      onDropMultiple,
      onLeave
    ) {
      this.onError = onError;
      this.onHover = onHover;
      this.onDrop = onDrop;
      this.onDropMultiple = onDropMultiple;
      this.onLeave = onLeave;
      this.dropMIME = null;
      this.dropOperation = "copy";
    }

    dragover_handler(event) {
      event.preventDefault();
      event.dataTransfer.dropEffect = this.dropOperation;
      if (this.onHover) this.onHover(event);
    }

    dragleave_handler(event) {
      event.preventDefault();
      if (this.onLeave) this.onLeave(event);
    }

    drop_handler(event) {
      event.preventDefault();

      const textData = event.dataTransfer.getData("text");
      console.log("textData");
      console.log(textData);
      console.log(event.dataTransfer);
      console.log("done");

      const files = [];
      const strings = [];
      if (event.dataTransfer.items) {
        for (let i = 0; i < event.dataTransfer.items.length; i += 1) {
          const item = event.dataTransfer.items[i];

          switch (item.kind) {
            case "file":
              if (!this.dropMIME || this.dropMIME.includes(item.type)) {
                const file = event.dataTransfer.items[i].getAsFile();

                if (this.onDrop) {
                  this.onDrop(event, file);
                }

                files.push(file);
              }

              break;
            case "string":
              const text = event.dataTransfer.getAsString();

              if (this.onDrop) {
                this.onDrop(event, text);
              }

              strings.push(text);
              break;
            default:
              if (this.onError) {
                this.onError(`Wrong type: ${item.kind}`);
              }
              break;
          }
        }
      } else {
        // not sure if this is useful. maybe an IE thing?
        for (let i = 0; i < event.dataTransfer.files.length; i += 1) {
          const file = event.dataTransfer.files[i];
          if (this.onDrop) {
            this.onDrop(event, file);
          }
          files.push(file);
        }
      }

      if (this.onDropMultiple) {
        if (files.length > 0) {
          this.onDropMultiple(event, files);
        }

        if (strings.length > 0) {
          this.onDropMultiple(event, strings);
        }
      }
    }

    setMIME(mime) {
      this.dropMIME = mime;
    }

    setOperation(operation) {
      this.dropOperation = operation;
    }
  }

  // must be var, some kind of wacko global
  var flutter_dropzone_web = {
    setMIME: function (container, mime) {
      container.FlutterDropzone.setMIME(mime);
      return true;
    },

    setOperation: function (container, operation) {
      container.FlutterDropzone.setOperation(operation);
      return true;
    },

    setCursor: function (container, cursor) {
      container.style.cursor = cursor;
      return true;
    },

    create: function (
      container,
      onLoaded,
      onError,
      onHover,
      onDrop,
      onDropMultiple,
      onLeave
    ) {
      if (container.FlutterDropzone === undefined)
        container.FlutterDropzone = new FlutterDropzone(
          container,
          onLoaded,
          onError,
          onHover,
          onDrop,
          onDropMultiple,
          onLeave
        );
      else
        container.FlutterDropzone.updateHandlers(
          onLoaded,
          onError,
          onHover,
          onDrop,
          onDropMultiple,
          onLeave
        );
    },
  };

  window.dispatchEvent(new Event("flutter_dropzone_web_ready"));
}
