library oauth2;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' show JSON;

class OAuth2Client {
  final Uri oauthUri;
  final Uri tokenUri;
  final Uri apiUri;
  
  final String _appId;
  final String _secret;
  
  
  OAuth2Client(this._appId, this._secret, { this.oauthUri, this.tokenUri, this.apiUri });
  
  Uri getRedirectionUri(Uri redirectUri, { Map params }) {
    if (params == null) {
      params = new Map();
    }
    params.addAll({
      'client_id': this._appId,
      'redirect_uri': redirectUri.toString(),
      'response_type':'code'
    });
    if (params['scopes'] is List) {
      params['scope'] = (params.remove('scopes') as List).join(' ');
    }
    
    return new Uri.https(this.oauthUri.authority, this.oauthUri.path, params);
  }

  Future<Map> getTokens(Uri redirectUri, String code) {
    http.Client client = new http.Client();
    
    return client.post(tokenUri, body: {
      'client_id': this._appId,
      'redirect_uri': redirectUri.toString(),
      'client_secret': this._secret,
      'code': code,
      'grant_type': 'authorization_code'
    })
      .then((http.Response response){
        return JSON.decode(response.body);
      });
  }
  

  Future<Map> refreshTokens(Uri redirectUri, String refreshToken) {
    http.Client client = new http.Client();
    
    return client.post(tokenUri, body: {
      'client_id': this._appId,
      'redirect_uri': redirectUri.toString(),
      'client_secret': this._secret,
      'refresh_token': refreshToken,
      'grant_type': 'refresh_token'
    })
      .then((http.Response response){
        return JSON.decode(response.body);
      });
  }
  
  Future<OAuth2Access> createAccess(Uri redirectUri, String code) {
    return getTokens(redirectUri, code).then((tokens) => new OAuth2Access(this, tokens));
  }
}


class OAuth2Access {
  final OAuth2Client client;
  final http.Client httpClient = new http.Client();
  
  final Map credentials;
  
  String get accessToken => credentials['access_token'];
  String get refreshToken => credentials['refresh_token'];
  String get expiration => credentials['expiration'];
  
  OAuth2Access(this.client, this.credentials) {
    assert(credentials != null);
    if (credentials['access_token'] == null) {
      throw new Exception(credentials.containsKey('error') ? credentials['error'] : 'No access token');
    }
  }
  
  Map me;
  
  String get meUrl => '${client.apiUri}/me?access_token=${accessToken}';
  
  Future<Map>retrieveMe() {
    return httpClient.get(meUrl)
      .then((http.Response response){
        return me = JSON.decode(response.body);
      });
  }
  
  bool isValidMe() {
    return me.isNotEmpty && me['error'] == null && me['id'] != null;
  }
}