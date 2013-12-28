library oauth2_windows_live;

import 'package:simple_oauth2_server/oauth2.dart';

/**
 * Windows Live connect, using OAuth 2
 * 
 * http://msdn.microsoft.com/fr-fr/library/hh243647.aspx
 * http://msdn.microsoft.com/fr-fr/library/hh243649.aspx
 * scopes : http://msdn.microsoft.com/en-us/library/hh243646.aspx
 * user api : http://msdn.microsoft.com/en-us/library/hh243648.aspx#user
 */
class OAuth2LiveClient extends OAuth2Client {
  final String _appId;
  final String _secret;
  
  OAuth2LiveClient(String appId, String secret)
    : super(appId, secret,
          oauthUri: Uri.parse('https://oauth.live.com/authorize'),
          tokenUri: Uri.parse('https://oauth.live.com/token'),
          apiUri: Uri.parse('https://apis.live.net/v5.0')
        ), _appId = appId, _secret = secret;
  
}