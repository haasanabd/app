class Currency {
  final String code;
  final String name;
  final String symbol;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
  });

  @override
  String toString() => '$name ($code)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;
}

class CurrencyData {
  static const List<Currency> currencies = [
    // Major currencies
    Currency(code: 'USD', name: 'الدولار الأمريكي', symbol: '\$'),
    Currency(code: 'EUR', name: 'اليورو', symbol: '€'),
    Currency(code: 'GBP', name: 'الجنيه الإسترليني', symbol: '£'),
    Currency(code: 'JPY', name: 'الين الياباني', symbol: '¥'),
    Currency(code: 'CHF', name: 'الفرنك السويسري', symbol: 'CHF'),
    Currency(code: 'CAD', name: 'الدولار الكندي', symbol: 'C\$'),
    Currency(code: 'AUD', name: 'الدولار الأسترالي', symbol: 'A\$'),
    Currency(code: 'NZD', name: 'الدولار النيوزيلندي', symbol: 'NZ\$'),
    
    // Middle East & North Africa
    Currency(code: 'IQD', name: 'الدينار العراقي', symbol: 'د.ع'),
    Currency(code: 'SAR', name: 'الريال السعودي', symbol: 'ر.س'),
    Currency(code: 'AED', name: 'الدرهم الإماراتي', symbol: 'د.إ'),
    Currency(code: 'KWD', name: 'الدينار الكويتي', symbol: 'د.ك'),
    Currency(code: 'QAR', name: 'الريال القطري', symbol: 'ر.ق'),
    Currency(code: 'BHD', name: 'الدينار البحريني', symbol: 'د.ب'),
    Currency(code: 'OMR', name: 'الريال العماني', symbol: 'ر.ع'),
    Currency(code: 'JOD', name: 'الدينار الأردني', symbol: 'د.أ'),
    Currency(code: 'LBP', name: 'الليرة اللبنانية', symbol: 'ل.ل'),
    Currency(code: 'SYP', name: 'الليرة السورية', symbol: 'ل.س'),
    Currency(code: 'EGP', name: 'الجنيه المصري', symbol: 'ج.م'),
    Currency(code: 'LYD', name: 'الدينار الليبي', symbol: 'د.ل'),
    Currency(code: 'TND', name: 'الدينار التونسي', symbol: 'د.ت'),
    Currency(code: 'DZD', name: 'الدينار الجزائري', symbol: 'د.ج'),
    Currency(code: 'MAD', name: 'الدرهم المغربي', symbol: 'د.م'),
    Currency(code: 'SDG', name: 'الجنيه السوداني', symbol: 'ج.س'),
    Currency(code: 'SOS', name: 'الشلن الصومالي', symbol: 'ش.ص'),
    Currency(code: 'DJF', name: 'الفرنك الجيبوتي', symbol: 'ف.ج'),
    Currency(code: 'KMF', name: 'الفرنك القمري', symbol: 'ف.ق'),
    Currency(code: 'MRU', name: 'الأوقية الموريتانية', symbol: 'أ.م'),
    Currency(code: 'IRR', name: 'الريال الإيراني', symbol: 'ر.إ'),
    Currency(code: 'AFN', name: 'الأفغاني', symbol: 'أف'),
    Currency(code: 'TRY', name: 'الليرة التركية', symbol: '₺'),
    Currency(code: 'ILS', name: 'الشيكل الإسرائيلي', symbol: '₪'),
    
    // Asia
    Currency(code: 'CNY', name: 'اليوان الصيني', symbol: '¥'),
    Currency(code: 'INR', name: 'الروبية الهندية', symbol: '₹'),
    Currency(code: 'KRW', name: 'الوون الكوري الجنوبي', symbol: '₩'),
    Currency(code: 'SGD', name: 'الدولار السنغافوري', symbol: 'S\$'),
    Currency(code: 'HKD', name: 'دولار هونغ كونغ', symbol: 'HK\$'),
    Currency(code: 'TWD', name: 'الدولار التايواني', symbol: 'NT\$'),
    Currency(code: 'THB', name: 'الباهت التايلاندي', symbol: '฿'),
    Currency(code: 'MYR', name: 'الرينغيت الماليزي', symbol: 'RM'),
    Currency(code: 'IDR', name: 'الروبية الإندونيسية', symbol: 'Rp'),
    Currency(code: 'PHP', name: 'البيزو الفلبيني', symbol: '₱'),
    Currency(code: 'VND', name: 'الدونغ الفيتنامي', symbol: '₫'),
    Currency(code: 'LAK', name: 'الكيب اللاوسي', symbol: '₭'),
    Currency(code: 'KHR', name: 'الريال الكمبودي', symbol: '៛'),
    Currency(code: 'MMK', name: 'الكيات الميانماري', symbol: 'K'),
    Currency(code: 'BDT', name: 'التاكا البنغلاديشية', symbol: '৳'),
    Currency(code: 'PKR', name: 'الروبية الباكستانية', symbol: '₨'),
    Currency(code: 'LKR', name: 'الروبية السريلانكية', symbol: 'Rs'),
    Currency(code: 'NPR', name: 'الروبية النيبالية', symbol: 'Rs'),
    Currency(code: 'BTN', name: 'النغولتروم البوتاني', symbol: 'Nu'),
    Currency(code: 'MVR', name: 'الروفية المالديفية', symbol: 'Rf'),
    Currency(code: 'MNT', name: 'التوغريك المنغولي', symbol: '₮'),
    Currency(code: 'KZT', name: 'التنغة الكازاخستانية', symbol: '₸'),
    Currency(code: 'UZS', name: 'السوم الأوزبكي', symbol: 'soʻm'),
    Currency(code: 'KGS', name: 'السوم القيرغيزي', symbol: 'с'),
    Currency(code: 'TJS', name: 'السوموني الطاجيكي', symbol: 'SM'),
    Currency(code: 'TMT', name: 'المانات التركماني', symbol: 'T'),
    
    // Europe
    Currency(code: 'RUB', name: 'الروبل الروسي', symbol: '₽'),
    Currency(code: 'UAH', name: 'الهريفنيا الأوكرانية', symbol: '₴'),
    Currency(code: 'BYN', name: 'الروبل البيلاروسي', symbol: 'Br'),
    Currency(code: 'PLN', name: 'الزلوتي البولندي', symbol: 'zł'),
    Currency(code: 'CZK', name: 'الكورونا التشيكية', symbol: 'Kč'),
    Currency(code: 'HUF', name: 'الفورنت المجري', symbol: 'Ft'),
    Currency(code: 'RON', name: 'الليو الروماني', symbol: 'lei'),
    Currency(code: 'BGN', name: 'الليف البلغاري', symbol: 'лв'),
    Currency(code: 'HRK', name: 'الكونا الكرواتية', symbol: 'kn'),
    Currency(code: 'RSD', name: 'الدينار الصربي', symbol: 'дин'),
    Currency(code: 'BAM', name: 'المارك البوسني', symbol: 'KM'),
    Currency(code: 'MKD', name: 'الدينار المقدوني', symbol: 'ден'),
    Currency(code: 'ALL', name: 'الليك الألباني', symbol: 'L'),
    Currency(code: 'MDL', name: 'الليو المولدوفي', symbol: 'L'),
    Currency(code: 'GEL', name: 'اللاري الجورجي', symbol: '₾'),
    Currency(code: 'AMD', name: 'الدرام الأرميني', symbol: '֏'),
    Currency(code: 'AZN', name: 'المانات الأذربيجاني', symbol: '₼'),
    Currency(code: 'SEK', name: 'الكرونا السويدية', symbol: 'kr'),
    Currency(code: 'NOK', name: 'الكرونا النرويجية', symbol: 'kr'),
    Currency(code: 'DKK', name: 'الكرونا الدنماركية', symbol: 'kr'),
    Currency(code: 'ISK', name: 'الكرونا الآيسلندية', symbol: 'kr'),
    
    // Africa
    Currency(code: 'ZAR', name: 'الراند الجنوب أفريقي', symbol: 'R'),
    Currency(code: 'NGN', name: 'النايرا النيجيرية', symbol: '₦'),
    Currency(code: 'GHS', name: 'السيدي الغاني', symbol: '₵'),
    Currency(code: 'KES', name: 'الشلن الكيني', symbol: 'KSh'),
    Currency(code: 'UGX', name: 'الشلن الأوغندي', symbol: 'USh'),
    Currency(code: 'TZS', name: 'الشلن التنزاني', symbol: 'TSh'),
    Currency(code: 'ETB', name: 'البير الإثيوبي', symbol: 'Br'),
    Currency(code: 'RWF', name: 'الفرنك الرواندي', symbol: 'FRw'),
    Currency(code: 'BIF', name: 'الفرنك البوروندي', symbol: 'FBu'),
    Currency(code: 'CDF', name: 'الفرنك الكونغولي', symbol: 'FC'),
    Currency(code: 'XAF', name: 'فرنك وسط أفريقيا', symbol: 'FCFA'),
    Currency(code: 'XOF', name: 'فرنك غرب أفريقيا', symbol: 'CFA'),
    Currency(code: 'MGA', name: 'الأرياري المدغشقري', symbol: 'Ar'),
    Currency(code: 'MUR', name: 'الروبية الموريشية', symbol: '₨'),
    Currency(code: 'SCR', name: 'الروبية السيشلية', symbol: '₨'),
    Currency(code: 'BWP', name: 'البولا البوتسوانية', symbol: 'P'),
    Currency(code: 'NAD', name: 'الدولار الناميبي', symbol: 'N\$'),
    Currency(code: 'SZL', name: 'الليلانغيني السوازيلاندي', symbol: 'L'),
    Currency(code: 'LSL', name: 'اللوتي الليسوتي', symbol: 'L'),
    Currency(code: 'ZMW', name: 'الكواشا الزامبية', symbol: 'ZK'),
    Currency(code: 'ZWL', name: 'الدولار الزيمبابوي', symbol: 'Z\$'),
    Currency(code: 'MWK', name: 'الكواشا المالاوية', symbol: 'MK'),
    Currency(code: 'MZN', name: 'الميتيكال الموزمبيقي', symbol: 'MT'),
    Currency(code: 'AOA', name: 'الكوانزا الأنغولية', symbol: 'Kz'),
    Currency(code: 'CVE', name: 'الإسكودو الرأس أخضري', symbol: '\$'),
    Currency(code: 'STN', name: 'الدوبرا الساو تومي', symbol: 'Db'),
    Currency(code: 'GMD', name: 'الدالاسي الغامبي', symbol: 'D'),
    Currency(code: 'SLE', name: 'الليون السيراليوني', symbol: 'Le'),
    Currency(code: 'LRD', name: 'الدولار الليبيري', symbol: 'L\$'),
    Currency(code: 'GNF', name: 'الفرنك الغيني', symbol: 'FG'),
    Currency(code: 'SLL', name: 'الليون السيراليوني القديم', symbol: 'Le'),
    Currency(code: 'CRC', name: 'الكولون الكوستاريكي', symbol: '₡'),
    
    // Americas
    Currency(code: 'BRL', name: 'الريال البرازيلي', symbol: 'R\$'),
    Currency(code: 'ARS', name: 'البيزو الأرجنتيني', symbol: '\$'),
    Currency(code: 'CLP', name: 'البيزو التشيلي', symbol: '\$'),
    Currency(code: 'COP', name: 'البيزو الكولومبي', symbol: '\$'),
    Currency(code: 'PEN', name: 'السول البيروفي', symbol: 'S/'),
    Currency(code: 'UYU', name: 'البيزو الأوروغوياني', symbol: '\$U'),
    Currency(code: 'PYG', name: 'الغواراني الباراغوياني', symbol: '₲'),
    Currency(code: 'BOB', name: 'البوليفيانو البوليفي', symbol: 'Bs'),
    Currency(code: 'VES', name: 'البوليفار الفنزويلي', symbol: 'Bs'),
    Currency(code: 'GYD', name: 'الدولار الغياني', symbol: 'G\$'),
    Currency(code: 'SRD', name: 'الدولار السورينامي', symbol: '\$'),
    Currency(code: 'MXN', name: 'البيزو المكسيكي', symbol: '\$'),
    Currency(code: 'GTQ', name: 'الكيتزال الغواتيمالي', symbol: 'Q'),
    Currency(code: 'BZD', name: 'الدولار البليزي', symbol: 'BZ\$'),
    Currency(code: 'HNL', name: 'الليمبيرا الهندوراسية', symbol: 'L'),
    Currency(code: 'NIO', name: 'الكوردوبا النيكاراغوية', symbol: 'C\$'),
    Currency(code: 'PAB', name: 'البالبوا البنمية', symbol: 'B/.'),
    Currency(code: 'CUP', name: 'البيزو الكوبي', symbol: '\$'),
    Currency(code: 'DOP', name: 'البيزو الدومينيكاني', symbol: 'RD\$'),
    Currency(code: 'HTG', name: 'الغورد الهايتي', symbol: 'G'),
    Currency(code: 'JMD', name: 'الدولار الجامايكي', symbol: 'J\$'),
    Currency(code: 'TTD', name: 'دولار ترينيداد وتوباغو', symbol: 'TT\$'),
    Currency(code: 'BBD', name: 'الدولار البربادوسي', symbol: 'Bds\$'),
    Currency(code: 'XCD', name: 'دولار شرق الكاريبي', symbol: 'EC\$'),
    Currency(code: 'BSD', name: 'الدولار الباهامي', symbol: 'B\$'),
    Currency(code: 'KYD', name: 'دولار جزر الكايمان', symbol: 'CI\$'),
    Currency(code: 'BMD', name: 'الدولار البرمودي', symbol: 'BD\$'),
    
    // Oceania
    Currency(code: 'FJD', name: 'الدولار الفيجي', symbol: 'FJ\$'),
    Currency(code: 'PGK', name: 'الكينا البابوا غينيا الجديدة', symbol: 'K'),
    Currency(code: 'SBD', name: 'دولار جزر سليمان', symbol: 'SI\$'),
    Currency(code: 'VUV', name: 'الفاتو الفانواتي', symbol: 'VT'),
    Currency(code: 'WST', name: 'التالا الساموي', symbol: 'WS\$'),
    Currency(code: 'TOP', name: 'البانغا التونغي', symbol: 'T\$'),
    Currency(code: 'XPF', name: 'فرنك المحيط الهادئ', symbol: '₣'),
    
    // Cryptocurrencies (optional)
    Currency(code: 'BTC', name: 'البيتكوين', symbol: '₿'),
    Currency(code: 'ETH', name: 'الإيثيريوم', symbol: 'Ξ'),
    Currency(code: 'USDT', name: 'التيثر', symbol: '₮'),
    Currency(code: 'BNB', name: 'بينانس كوين', symbol: 'BNB'),
    Currency(code: 'ADA', name: 'كاردانو', symbol: 'ADA'),
    Currency(code: 'XRP', name: 'الريبل', symbol: 'XRP'),
    Currency(code: 'SOL', name: 'سولانا', symbol: 'SOL'),
    Currency(code: 'DOT', name: 'بولكادوت', symbol: 'DOT'),
    Currency(code: 'DOGE', name: 'دوجكوين', symbol: 'DOGE'),
    Currency(code: 'AVAX', name: 'أفالانش', symbol: 'AVAX'),
  ];

  static Currency? findByCode(String code) {
    try {
      return currencies.firstWhere((currency) => currency.code == code);
    } catch (e) {
      return null;
    }
  }

  static List<Currency> searchCurrencies(String query) {
    if (query.isEmpty) return currencies;
    
    final lowerQuery = query.toLowerCase();
    return currencies.where((currency) =>
        currency.code.toLowerCase().contains(lowerQuery) ||
        currency.name.toLowerCase().contains(lowerQuery) ||
        currency.symbol.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}

