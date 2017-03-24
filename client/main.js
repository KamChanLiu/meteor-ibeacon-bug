Meteor.startup(function() {
  if (Meteor.isClient) {
    console.log('startup fired');

    Meteor.setTimeout(function () {
      console.log('Starting CoreLocationPlugin');
      CoreLocationPlugin.startAllManager();
    }, 5000);
  }
});
