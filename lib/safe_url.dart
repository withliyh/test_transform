String _urlsym =
    r'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-_.*%';
Set<int> _urlsymcodes = Set.from(_urlsym.codeUnits);

void testUrlEncode() {
  final urlstr =
      'https://gcdncs.101.com/v0.1/static/ppt_push/ppt_parsing/test/[SkyWalks][一人之下][The Outcast][03][简体][720P]_1674910605241.mp4';

  assert(hasUrlEncode(urlstr) == false);
  assert(hasUrlEncode(Uri.encodeComponent(urlstr)) == true);

  final url2 = '%E5%BD%95%E5%88%B6_2022_12_30_09_58_23_382';
  assert(hasUrlEncode(url2) == true);
}

bool hasUrlEncode(String url) {
  if (url.isEmpty) {
    return false;
  }
  for (int i = 0; i < url.length; i++) {
    int charcode = url.codeUnitAt(i);
    if (!_urlsymcodes.contains(charcode)) {
      return false;
    }
    if (charcode == r'%'.codeUnitAt(0) && (i + 2) < url.length) {
      int c1 = url.codeUnitAt(i + 1);
      int c2 = url.codeUnitAt(i + 2);
      if (!isDigit16Char(c1) || !isDigit16Char(c2)) {
        return false;
      }
    }
  }
  return true;
}

bool isDigit16Char(int codeUnit) {
  return (codeUnit >= '0'.codeUnitAt(0) && codeUnit <= '9'.codeUnitAt(0)) ||
      (codeUnit >= 'A'.codeUnitAt(0) && codeUnit <= 'F'.codeUnitAt(0)) ||
      (codeUnit >= 'a'.codeUnitAt(0) && codeUnit <= 'f'.codeUnitAt(0));
}
