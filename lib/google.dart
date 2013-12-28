library oauth2_google;

import 'dart:async';
import 'dart:convert' show JSON;
import 'package:http/http.dart' as http;

import 'package:simple_oauth2_server/oauth2.dart';

/**
 * Google connect, using OAuth 2
 * 
 * Scopes : https://developers.google.com/gdata/faq#AuthScopes
 */
class OAuth2GoogleClient extends OAuth2Client {
  final String _appId;
  final String _secret;
  
  OAuth2GoogleClient(String appId, String secret)
    : super(appId, secret,
          oauthUri: Uri.parse('https://accounts.google.com/o/oauth2/auth'),
          tokenUri: Uri.parse('https://accounts.google.com/o/oauth2/token'),
          apiUri: Uri.parse('https://www.googleapis.com/oauth2/v1/')
        ), _appId = appId, _secret = secret;

  Uri getRedirectionUri(Uri redirectUri, { Map params, offline: false }) {
    if (offline) {
      params['access_type'] = 'offline';
      params['approval_prompt'] = 'force';
    }
    return super.getRedirectionUri(redirectUri, params: params);
  }
  

  Future<OAuth2GoogleAccess> createAccess(Uri redirectUri, String code) {
    return getTokens(redirectUri, code).then((tokens) => new OAuth2GoogleAccess(this, tokens));
  }
}

class OAuth2GoogleAccess extends OAuth2Access {
  OAuth2GoogleAccess(OAuth2GoogleClient client, tokens) : super(client, tokens);

  String get meUrl => 'https://www.googleapis.com/oauth2/v1/userinfo?access_token=${accessToken}';
  
  Future<Map> allContacts([ minUpdated ]){
    var params = {
      'v': '3',
      'alt': 'json',
      'max-results': '99999',
      'access_token': accessToken
      
    };
    if (minUpdated != null) {
      params['min-updated'] = minUpdated; //toRFC3339Time
    }
    
    var uri = new Uri.https('www.google.com','/m8/feeds/contacts/default/full', params);
    
    return httpClient.get(uri)
      .then((http.Response response){
        return JSON.decode(response.body);
      });
  }
}

