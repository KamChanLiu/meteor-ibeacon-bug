Meteor.startup(function() {
  if (Meteor.isClient) {
    console.log('startup fired');
    CoreLocationPlugin.startAllManager();
  }
});
