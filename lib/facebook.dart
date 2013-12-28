library oauth2_facebook;

import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:simple_oauth2_server/oauth2.dart';

/**
 * Facebook connect, using OAuth 2
 */
class OAuth2FacebookClient extends OAuth2Client {
  final String _appId;
  final String _secret;
  
  OAuth2FacebookClient(String appId, String secret)
    : super(appId, secret,
          oauthUri: Uri.parse('https://www.facebook.com/dialog/oauth'),
          tokenUri: Uri.parse('https://graph.facebook.com/oauth/access_token'),
          apiUri: Uri.parse('https://graph.facebook.com')
        ), _appId = appId, _secret = secret;
  
  getTokens(String redirectUri, String code) {
    http.Client client = new http.Client();
    
    var tokenUrl = new Uri.https(tokenUri.authority, tokenUri.path, {
      'client_id': _appId,
      'redirect_uri': redirectUri,
      'client_secret': _secret,
      'code': code
    });
    
    return client.get(tokenUrl)
      .then((http.Response response){
        return Uri.splitQueryString(response.body);
      });
  }
}