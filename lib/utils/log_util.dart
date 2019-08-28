class LogUtil {
  static const String _TAG_DEF = "======= log =======";

  static bool _debuggable = false; //是否是debug模式,true: log v 不输出.
  static String _tag = _TAG_DEF;

  static void init({bool isDebug = false, String tag = _TAG_DEF}) {
    _debuggable = isDebug;
    _tag = tag;
  }

  static void e(Object object, {String tag}) {
    _printLog(tag, '  e  ', object);
  }

  static void d(Object object, {String tag}) {
    if (_debuggable) {
      _printLog(tag, '  d  ', object);
    }
  }

  static void _printLog(String tag, String stag, Object object) {
    StringBuffer sb = new StringBuffer();
    sb.write((tag == null || tag.isEmpty) ? _tag : tag);
    sb.write(stag);
    sb.write(object);
    print(sb.toString());
  }
}
