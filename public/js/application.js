var source = new EventSource('/data-stream');
var data_ul = $('ul.data');

source.addEventListener('data', function(notification) {
  var data = JSON.parse(notification.data);
  element = "node_name: " + data.node_name + ", channel: " + data.channel + ", payload: " + data.payload + ", updated: " + data.updated;
  data_ul.prepend('<li>' +  element + '</li>');
}, false);
