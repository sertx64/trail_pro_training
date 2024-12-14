import 'package:gsheets/gsheets.dart';

const _credentials = r'''
{
  "type": "service_account",
  "project_id": "snttest",
  "private_key_id": "353cbf3166788bbafad090412b9a34b3b3681593",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCKjq7YAXyr4hZS\nyAu6iUpu4lGtwtwUc5SdOTTYuby9mY5FRDE58xuwU4YNRfSAD7LhdRxWQPuX+iPI\n6nIJmhPAoQDg5KdJcAeJ8cwfQEHJ/vEH5w2b0BIIFdbZ735occH/QvGhAIoA2M1a\njNTMvuKHaXtMH3XbB5WD+LTjzRRngMoTeaphJEErQu5RaIxpEtFMsWnZO9nrJXkc\ngT6hKuTbj3oetK4oHIEgQnSratbF0+Mnjj6Zk3JPTtrPeLSzkcOeVoOLHLCKXldC\nf20koSF+Jc19D2C4X4LloZZlIxGz9ws8WUoC6VlYmEiP1/PVsW9CCXSZmYSO83aK\n555PSUTVAgMBAAECggEADRZblPsU+c5F4gVTuEeaAH2/jcxbSdI9/hjGcVcf6P+9\nVLUTekAIhD/raEsMhGEXOhz783i5WvpNUX+1jEshpP8ALH3kgDcE+0Zby7Lf0/LQ\n9PhhzG8bmOhpLhYlSDvAgXojBRxeLKTNxskJG5rHHle8Be1tziW5/WhrO54mGH2J\n5JX65QkZBxLbYOTo3StHllb8ysToSAmUvFGbCb1i5JIwtxOO+q5G8N7RvcwOTxwk\nSxytblYLKZvLwGamx4MAFVQ2X8ATc5a4iqgnXbT3Xca2IcItBTLl6U9k9WFTRFHS\nBDrk91dnedcwMq+TypbD7+lq00LTuw6kXcfFC2IwoQKBgQC8Wo/U0srn6b28oG07\n+rR5l7PoAV5WckYgOECB1uXvada89VpJR2TN63/mcaHQDAeVkrRqyj/kH7P+l6AO\nuXaXZQHM64xmbjjeJlaMdu6yG+i1Nni1iF58dp/le1JpQEeORxowu5Yzudw6gk3d\ntEAjvtlkcBws9lTbaCgPHHyKNQKBgQC8UcnrRFgLGPnj/AzpGfzBCL362+uSgdI8\nk+KjpwcDZ0al+Ig5TM9UX0XarTdo4Dge1uLh5rF2kNVFJjOvSRf5X89oBMXI3h3W\nbvSSkGIMLtIE7tnMLxZUND+pSufc1TKkoEPQwzhwXr2f8w+Clql2/YM4DWHh70Oo\njGUvOhwkIQKBgAKA1Z6HeqjgY2QpYapFZ7ah/IMd2YoelK4C8WCIYZ/v8SmrvRpy\nN3XBJn8CjZr9PfCP9ZPhwj2e6j5892SatGfIsOBvVPtbhaf2LHpLblqxokMeSTZo\nbJEM5o0fOXYqo4jRixiQtatUUgf5CV3j8mJHPA5oqwcx8ujDlpy0zTbtAoGBALrW\n8tznG+s2xod5xV1omSrz/3lqxJjBENNlblEsIHsx9hgpMw6WtIVjWS0S+oylGUkP\nrl6uwZd/LvnCYzkf7hdPBbqQMaOPLE9aGnFnqr+nnFuklpZMiXzVsevHE7A4HlzT\nXTU82zwx4zVUtCi+TjhuYcg1Ds5Y0unhEWr/3nfBAoGAEApdxhQN94wYXVAMibr7\n9G1apFj9IpfHF06SHA+/jMzEG6M+dp8UWVUGNbCOCVv0KaXU6GCxjxmfLriqbV7g\nXP5fy5BOmhmMocvcpklKNXS1zODYQsa+MNwu82K0Xhhg/6fa51qDic0uorhnlpuP\n8iCl6q3+6/PW4wW9BM/t00M=\n-----END PRIVATE KEY-----\n",
  "client_email": "snttestacc@snttest.iam.gserviceaccount.com",
  "client_id": "102694116734991217814",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/snttestacc%40snttest.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';
const _spreadsheetId = '182H6VT_Phx-4by5_fWefCMLdUPTaR6cXwPt5FD-OjZs';

class ApiGSheet {
  final gSheets = GSheets(_credentials);

  Future<List<String>?> getWeekPlanList(String id) async {
    final ss = await gSheets.spreadsheet(_spreadsheetId);
    final weekPlanSheet = ss.worksheetByTitle('tp_week_plan');
    final weekplanlist = await weekPlanSheet!.values.rowByKey(id);

    return weekplanlist;
  }

  void sendWeekPlanList(String id, List weekplanlist) async {
    final ss = await gSheets.spreadsheet(_spreadsheetId);
    final weekPlanSheet = ss.worksheetByTitle('tp_week_plan');

    await weekPlanSheet!.values.insertRowByKey(id, weekplanlist);
  }

  Future<List<String>?> getAuthUserList() async {
    final ss = await gSheets.spreadsheet(_spreadsheetId);
    final sheet = ss.worksheetByTitle('auth_user');
    final authUserList = await sheet!.values.columnByKey('loginpin');

    return authUserList;
  }

  Future<List<String>?> getReportsList(String date) async {
    final ss = await gSheets.spreadsheet(_spreadsheetId);
    final sheet = ss.worksheetByTitle('reports');
    final reportsList = await sheet!.values.columnByKey(date);

    return reportsList;
  }

  void sendReportsList(String date, List reportList) async {
    final ss = await gSheets.spreadsheet(_spreadsheetId);
    final sheet = ss.worksheetByTitle('reports');

    await sheet!.values.insertColumnByKey(date, reportList);
  }



}
