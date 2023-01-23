if (typeof FlutterDropzone === 'undefined') {
    class FlutterDropzone {
        constructor(container, onLoaded, onError, onHover, onDrop, onDropMultiple, onLeave) {
            this.onError = onError;
            this.onHover = onHover;
            this.onDrop = onDrop;
            this.onDropMultiple = onDropMultiple;
            this.onLeave = onLeave;
            this.dropMIME = null;
            this.dropOperation = 'copy';

            container.addEventListener('dragover', this.dragover_handler.bind(this));
            container.addEventListener('dragleave', this.dragleave_handler.bind(this));
            container.addEventListener('drop', this.drop_handler.bind(this));

            if (onLoaded != null) onLoaded();
        }

        async getFile(fileEntry) {
            try {
                return await new Promise((resolve, reject) => fileEntry.file(resolve, reject));
            } catch (err) {
                console.log(err);
            }
        }

        file_handler(fileEntry, files, event) {
            if (fileEntry.isFile) {
                this.getFile(fileEntry).then(file => {
                    if (this.onDrop != null) this.onDrop(event, file);
                    files.push(file)
                });
            } else if (fileEntry.isDirectory) {
                this.getFile(fileEntry).then(file => {
                    if (this.onDrop != null) this.onDrop(event, file);
                    files.push(file)
                });
            }
        }

        updateHandlers(onLoaded, onError, onHover, onDrop, onDropMultiple, onLeave) {
            this.onError = onError;
            this.onHover = onHover;
            this.onDrop = onDrop;
            this.onDropMultiple = onDropMultiple;
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

        drop_handler(event) {
            event.preventDefault();

            var files = [];
            var strings = [];
            if (event.dataTransfer.items) {
                for (var i = 0; i < event.dataTransfer.items.length; i++) {
                    var item = event.dataTransfer.items[i];
                    switch (item.kind) {
                        case "file":
                            if (this.dropMIME == null || this.dropMIME.includes(item.type)) {
                                var fileEntry = item.webkitGetAsEntry();

                                if (fileEntry) {
                                    this.file_handler(fileEntry, files, event);
                                }
                            }
                            break;

                        case "string":
                            item.getAsString((text) => {
                                if (this.onDrop != null) this.onDrop(event, text);
                                strings.push(text);
                            });
                            break;

                        default:
                            if (this.onError != null) this.onError("Wrong type: ${item.kind}");
                            break;
                    }
                }
            } else {
                for (var i = 0; i < ev.dataTransfer.files.length; i++)
                    var file = event.dataTransfer.files[i];
                if (this.onDrop != null) this.onDrop(event, file);
                files.push(file);
            }

            //setTimeout: To avoid .length wrong caused by async modification
            setTimeout(() => {
                if (this.onDropMultiple != null) {
                    if (files.length > 0) this.onDropMultiple(event, files);
                    if (strings.length > 0) this.onDropMultiple(event, strings);
                }
            }, 100);
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

        create: function(container, onLoaded, onError, onHover, onDrop, onDropMultiple, onLeave) {
            if (container.FlutterDropzone === undefined)
                container.FlutterDropzone = new FlutterDropzone(container, onLoaded, onError, onHover, onDrop, onDropMultiple, onLeave);
            else
                container.FlutterDropzone.updateHandlers(onLoaded, onError, onHover, onDrop, onDropMultiple, onLeave);
        },
    };

    window.dispatchEvent(new Event('flutter_dropzone_web_ready'));
}