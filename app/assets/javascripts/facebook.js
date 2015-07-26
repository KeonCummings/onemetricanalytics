$(document).ready(function() {
  $('body').prepend('<div id="fb-root"></div>')
  $.ajaxSetup({ cache: true });
  $.getScript('//connect.facebook.net/en_US/sdk.js', function(){
    FB.init({
      appId: '399575120226034',
      version: 'v2.3', // or v2.0, v2.1, v2.0
      cookie: true
    });     
  });
   $('#sign_in').click(function(e) {
      e.preventDefault();
      return FB.login(function(response) {
        if (response.authResponse) {
          return window.location = '/auth/facebook/callback';
        }  
      });
    });

    $('#sign_out').click(function(e) {
      FB.getLoginStatus(function(response) {
        if (response.authResponse) {
          return FB.logout();
        }
      });
      return true;
    });
})
