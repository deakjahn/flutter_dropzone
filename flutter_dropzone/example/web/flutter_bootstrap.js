{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  config: {
//    renderer: 'canvaskit',
  },
  serviceWorkerSettings: {
    serviceWorkerUrl: 'flutter_service_worker.js?v=',
    serviceWorkerVersion: {{flutter_service_worker_version}},
  },
});