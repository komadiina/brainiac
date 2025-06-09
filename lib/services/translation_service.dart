import 'package:mozgalica/resources/configurations/locale.dart';

@Deprecated('Replaced with i18n (intl) package')
class TranslationService {
  static Map<String, Map<String, String>> _locale = {};
  static String _lang = 'en';

  static void init() {
    _locale = locale;
  }

  static void toggleLanguage() {
    _lang = _lang == 'en' ? 'sr-Latn' : 'en';
  }

  static void setLanguage(String language) {
    _lang = language;
  }

  static String getTranslation(String key) {
    return (_locale[_lang])?[key] ?? key;
  }
}