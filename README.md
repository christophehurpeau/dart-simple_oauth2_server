[![Build Status](https://drone.io/github.com/christophehurpeau/dart-simple_oauth2_server/status.png)](https://drone.io/github.com/christophehurpeau/dart-simple_oauth2_server/latest)

See the [auto-generated docs](http://christophehurpeau.github.io/dart-simple_oauth2_server/docs/oauth2.html)

### How to use

```
part of server;

Map authController(){
  
  final identifier = "*********.apps.googleusercontent.com";
  final secret = "*************";
  
  final redirectUrl = Uri.parse("http://localhost:4040/auth/google-response");
  final googleOauthClient = new OAuth2GoogleClient(identifier, secret);
  
  final uuid = new Uuid();
  
  return {
    'google': (HttpRequest request, HttpResponse response){
      var state = uuid.v1();
      request.session['auth.googleUuid'] = state;
      
      var redirectTo = googleOauthClient.getRedirectionUri(redirectUrl, params: {
          'state': state,
          'scopes': ['https://www.googleapis.com/auth/userinfo.profile',
                          'https://www.googleapis.com/auth/userinfo.email']
      });
      
      response.redirect(redirectTo);
    },
    'google-response': (HttpRequest request, HttpResponse response){
      var state = request.uri.queryParameters['state'];
      if (state != null && (request.session['auth.googleUuid'] == null 
          || state != request.session['auth.googleUuid'])) {
        response.redirect(Uri.parse('/auth/google'));
        return;
      }
      
      
      googleOauthClient.createAccess(redirectUrl, request.uri.queryParameters['code'])
        .then((OAuth2GoogleAccess _access){
          access.retrieveMe()
            .then((Map me){
              print(me);
            });
        });
      });
    },
  };
}
```