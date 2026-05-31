import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════════════════════
// HOW TO INTEGRATE
// ════════════════════════════════════════════════════════════════════════════
//
//  1. Add this file to your project (e.g. lib/localization.dart)
//
//  2. In your main.dart AgriMarketApp, change MaterialApp to:
//
//       MaterialApp(
//         ...
//         locale: AppLocale.instance.locale,     // <-- add
//         localizationsDelegates: const [        // <-- add
//           AppLocalizationsDelegate(),
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//         ],
//         supportedLocales: AppLocale.supportedLocales, // <-- add
//         ...
//       )
//
//     You'll also need to wrap MaterialApp in a StatefulBuilder or use a
//     ValueListenableBuilder on AppLocale.instance.localeNotifier.
//     A ready-made wrapper is provided below as LocalizedApp.
//
//  3. Use translations anywhere:
//       AppL10n.of(context).hello        // → 'Hello' / 'හෙලෝ' / 'வணக்கம்'
//
//  4. Change language:
//       AppLocale.instance.setLocale('si');   // Sinhala
//       AppLocale.instance.setLocale('ta');   // Tamil
//       AppLocale.instance.setLocale('en');   // English
//
// ════════════════════════════════════════════════════════════════════════════

// ════════════════════════════════════════════════════════════════════════════
// LOCALE MANAGER  — singleton, notifies the whole app on change
// ════════════════════════════════════════════════════════════════════════════

class AppLocale {
  AppLocale._();
  static final AppLocale instance = AppLocale._();

  final ValueNotifier<Locale> localeNotifier =
      ValueNotifier(const Locale('en'));

  Locale get locale => localeNotifier.value;

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('si'),
    Locale('ta'),
  ];

  void setLocale(String languageCode) {
    localeNotifier.value = Locale(languageCode);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// LOCALIZATIONS DELEGATE
// ════════════════════════════════════════════════════════════════════════════

class AppLocalizationsDelegate extends LocalizationsDelegate<AppL10n> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'si', 'ta'].contains(locale.languageCode);

  @override
  Future<AppL10n> load(Locale locale) async => AppL10n(locale.languageCode);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

// ════════════════════════════════════════════════════════════════════════════
// AppL10n — all translated strings
// ════════════════════════════════════════════════════════════════════════════

class AppL10n {
  final String lang;
  AppL10n(this.lang);

  static AppL10n of(BuildContext context) =>
      Localizations.of<AppL10n>(context, AppL10n) ?? AppL10n('en');

  // ── helper ────────────────────────────────────────────────────────────────
  String _t(String en, String si, String ta) {
    switch (lang) {
      case 'si':
        return si;
      case 'ta':
        return ta;
      default:
        return en;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // COMMON
  // ══════════════════════════════════════════════════════════════════════════
  String get appName => _t('Grow Mate', 'ග්‍රෝ මේට්', 'க்ரோ மேட்');
  String get cancel => _t('Cancel', 'අවලංගු කරන්න', 'ரத்து செய்');
  String get save => _t('Save', 'සුරකින්න', 'சேமி');
  String get edit => _t('Edit', 'සංස්කරණය', 'திருத்து');
  String get delete => _t('Delete', 'මකන්න', 'நீக்கு');
  String get confirm => _t('Confirm', 'තහවුරු කරන්න', 'உறுதிப்படுத்து');
  String get back => _t('Back', 'ආපසු', 'பின்னால்');
  String get search => _t('Search', 'සොයන්න', 'தேடு');
  String get noResults =>
      _t('No results found', 'ප්‍රතිඵල නොමැත', 'முடிவுகள் இல்லை');
  String get comingSoon => _t('Coming soon!', 'ශීඝ්‍රයේදීම!', 'விரைவில்!');
  String get yes => _t('Yes', 'ඔව්', 'ஆம்');
  String get no => _t('No', 'නැත', 'இல்லை');
  String get ok => _t('OK', 'හරි', 'சரி');
  String get error => _t('Error', 'දෝෂය', 'பிழை');
  String get success => _t('Success', 'සාර්ථකයි', 'வெற்றி');
  String get loading => _t('Loading...', 'පූරණය වේ...', 'ஏற்றுகிறது...');

  // ══════════════════════════════════════════════════════════════════════════
  // NAVIGATION
  // ══════════════════════════════════════════════════════════════════════════
  String get navHome => _t('Home', 'ගෙදර', 'முகப்பு');
  String get navMarket => _t('Market', 'වෙළඳපොළ', 'சந்தை');
  String get navOrders => _t('Orders', 'ඇණවුම්', 'ஆர்டர்கள்');
  String get navListings =>
      _t('My Listings', 'මගේ ලැයිස්තු', 'என் பட்டியல்கள்');
  String get navProfile => _t('Profile', 'පැතිකඩ', 'சுயவிவரம்');
  String get navSettings => _t('Settings', 'සැකසුම්', 'அமைப்புகள்');
  String get navPostProduct =>
      _t('Post Product', 'නිෂ්පාදනය පළ කරන්න', 'தயாரிப்பை இடு');

  // ══════════════════════════════════════════════════════════════════════════
  // HOME SCREEN
  // ══════════════════════════════════════════════════════════════════════════
  String get goodMorning => _t('Good Morning', 'සුබ උදෑසනක්', 'காலை வணக்கம்');
  String get goodAfternoon => _t('Good Afternoon', 'සුබ දවසක්', 'மதிய வணக்கம்');
  String get goodEvening =>
      _t('Good Evening', 'සුබ සන්ධ්‍යාවක්', 'இரவு வணக்கம்');
  String get activeCrops =>
      _t('Active\nCrops', 'සක්‍රිය\nබෝග', 'செயலில்\nபயிர்கள்');
  String get todaysTasks =>
      _t("Today's\nTasks", 'අද\nකාර්යයන්', 'இன்று\nபணிகள்');
  String get marketListings =>
      _t('Market\nListings', 'වෙළඳ\nලැයිස්තු', 'சந்தை\nபட்டியல்');
  String get machinesNearby =>
      _t('Machines\nNearby', 'ආසන්න\nයන්ත්‍ර', 'அருகில்\nயந்திரங்கள்');
  String get myCrops => _t('My Crops', 'මගේ බෝග', 'என் பயிர்கள்');
  String get quickActions =>
      _t('Quick Actions', 'ඉක්මන් ක්‍රියා', 'விரைவு செயல்கள்');
  String get marketSpotlight =>
      _t('Market Spotlight', 'වෙළඳ දර්ශනය', 'சந்தை ஸ்பாட்லைட்');
  String get todaysPrices =>
      _t("Today's Prices", 'අදේ මිල ගණන්', 'இன்றைய விலைகள்');
  String get alertsTips =>
      _t('Alerts & Tips', 'අනතුරු ඇඟවීම් & ඉඟි', 'எச்சரிக்கைகள் & குறிப்புகள்');
  String get seeAll => _t('See All', 'සියල්ල බලන්න', 'அனைத்தும் காண்');
  String get viewMore => _t('View More', 'තව බලන්න', 'மேலும் காண்');
  String get fullList => _t('Full List', 'සම්පූර්ණ ලැයිස්තුව', 'முழு பட்டியல்');
  String get growing => _t('Growing', 'වර්ධනය', 'வளர்கிறது');
  String get harvesting => _t('Harvesting', 'අස්වනු නෙලීම', 'அறுவடை');
  String get growthStage => _t('Growth stage', 'වර්ධන අදියර', 'வளர்ச்சி நிலை');
  String get complete => _t('complete', 'සම්පූර්ණයි', 'முடிந்தது');
  String get region => _t('Region', 'කලාපය', 'பிரதேசம்');
  String get humidity => _t('Humidity', 'ආර්ද්‍රතාව', 'ஈரப்பதம்');
  String get wind => _t('Wind', 'සුළඟ', 'காற்று');
  String get partlyCloudy =>
      _t('Partly Cloudy', 'අර්ධ වලාකුළු', 'குறிப்பிட்ட மேகம்');
  String get irrigationAlert =>
      _t('Irrigation Alert', 'වාරිමාර්ග අනතුරු ඇඟවීම', 'நீர்ப்பாசன எச்சரிக்கை');
  String get pestWarning =>
      _t('Pest Warning', 'කෘමි අනතුරු ඇඟවීම', 'பூச்சி எச்சரிக்கை');
  String get weatherUpdate =>
      _t('Weather Update', 'කාලගුණ යාවත්කාලීන', 'வானிலை புதுப்பிப்பு');

  // Quick action labels
  String get aiChat => _t('AI Chat', 'AI කතාබස්', 'AI அரட்டை');
  String get machine => _t('Machine', 'යන්ත්‍රය', 'இயந்திரம்');
  String get weather => _t('Weather', 'කාලගුණය', 'வானிலை');
  String get soilTest => _t('Soil Test', 'පස් පරීක්‍ෂා', 'மண் சோதனை');
  String get irrigation => _t('Irrigation', 'වාරිමාර්ග', 'நீர்ப்பாசனம்');
  String get pestAlert => _t('Pest Alert', 'කෘමි අනතුර', 'பூச்சி எச்சரிக்கை');
  String get reports => _t('Reports', 'වාර්තා', 'அறிக்கைகள்');

  // ══════════════════════════════════════════════════════════════════════════
  // MARKETPLACE
  // ══════════════════════════════════════════════════════════════════════════
  String get marketplace => _t('Marketplace', 'වෙළඳ ස්ථානය', 'சந்தை இடம்');
  String get sortBy => _t('Sort:', 'වර්ග කිරීම:', 'வரிசைப்படுத்து:');
  String get results => _t('results', 'ප්‍රතිඵල', 'முடிவுகள்');
  String get newest => _t('Newest', 'නවතම', 'புதியது');
  String get priceAsc => _t('Price ↑', 'මිල ↑', 'விலை ↑');
  String get priceDesc => _t('Price ↓', 'මිල ↓', 'விலை ↓');
  String get rating => _t('Rating', 'ශ්‍රේණිය', 'மதிப்பீடு');
  String get inStock => _t('In Stock', 'ගබඩාවේ ඇත', 'கையிருப்பில் உள்ளது');
  String get limited => _t('Limited', 'සීමිත', 'குறைவான இருப்பு');
  String get addToCart => _t('Add to Cart', 'කූඩයට එක් කරන්න', 'கூடையில் சேர்');
  String get searchMarket => _t('Search in marketplace...',
      'වෙළඳ ස්ථානයේ සොයන්න...', 'சந்தையில் தேடுங்கள்...');
  String get categories => _t('Categories', 'කාණ්ඩ', 'வகைகள்');
  String get featuredProducts =>
      _t('Featured Products', 'විශේෂ නිෂ්පාදන', 'சிறப்பு தயாரிப்புகள்');
  String get hotDeal => _t('Hot Deal', 'හොඳ ගනුදෙනුව', 'சிறந்த சலுகை');
  String get topSeller => _t('Top Seller', 'ඉහළ විකුණුම', 'சிறந்த விற்பனை');
  String get popular => _t('Popular', 'ජනප්‍රිය', 'பிரபலமான');

  // ══════════════════════════════════════════════════════════════════════════
  // PRODUCT / SELL
  // ══════════════════════════════════════════════════════════════════════════
  String get postProduct =>
      _t('Post Product to Sell', 'නිෂ්පාදනය විකිණීමට', 'விற்க தயாரிப்பு இடு');
  String get productCategory =>
      _t('Product Category *', 'නිෂ්පාදන කාණ්ඩය *', 'தயாரிப்பு வகை *');
  String get productName =>
      _t('Product Name *', 'නිෂ්පාදන නාමය *', 'தயாரிப்பு பெயர் *');
  String get priceLabel => _t('Price (Rs.) *', 'මිල (රු.) *', 'விலை (ரூ.) *');
  String get unitLabel => _t('Unit *', 'ඒකක *', 'அலகு *');
  String get quantityAvailable =>
      _t('Quantity Available', 'ලබා ගත හැකි ප්‍රමාණය', 'கிடைக்கும் அளவு');
  String get description => _t('Description', 'විස්තරය', 'விளக்கம்');
  String get locationLabel => _t('Location *', 'ස්ථානය *', 'இடம் *');
  String get selectDistrict => _t('Select your district',
      'ඔබේ දිස්ත්‍රික්කය තෝරන්', 'உங்கள் மாவட்டம் தேர்வு செய்க');
  String get addPhotos =>
      _t('Add Product Photos', 'නිෂ්පාදන ඡායාරූප', 'தயாரிப்பு புகைப்படங்கள்');
  String get uploadPhotos =>
      _t('Upload up to 5 photos', 'ඡායාරූප 5ක් දක්වා', '5 வரை புகைப்படங்கள்');
  String get postProductBtn =>
      _t('Post Product', 'නිෂ්පාදනය පළ කරන්න', 'தயாரிப்பை இடு');
  String get productPosted => _t('✅ Product posted! Visible on Home & Market.',
      '✅ නිෂ්පාදනය පළ කරන ලදී!', '✅ தயாரிப்பு இடப்பட்டது!');
  String get editProduct =>
      _t('Edit Product', 'නිෂ්පාදනය සංස්කරණය', 'தயாரிப்பை திருத்து');
  String get saveChanges =>
      _t('Save Changes', 'වෙනස්කම් සුරකින්', 'மாற்றங்களை சேமி');
  String get deleteProduct =>
      _t('Delete Product', 'නිෂ්පාදනය මකන්න', 'தயாரிப்பை நீக்கு');
  String get yourListing =>
      _t('Your Listing', 'ඔබේ ලැයිස්තුව', 'உங்கள் பட்டியல்');
  String get noListingsYet =>
      _t('No listings yet', 'ලැයිස්තු නොමැත', 'பட்டியல்கள் இல்லை');
  String get myListings => _t('My Listings', 'මගේ ලැයිස්තු', 'என் பட்டியல்கள்');
  String get changesReflect => _t(
      'Changes reflect immediately on Home & Market.',
      'වෙනස්කම් ක්‍ෂණිකව සිදු වේ.',
      'மாற்றங்கள் உடனடியாக காட்டும்.');

  // ══════════════════════════════════════════════════════════════════════════
  // PRODUCT DETAIL
  // ══════════════════════════════════════════════════════════════════════════
  String get details => _t('Details', 'විස්තර', 'விவரங்கள்');
  String get specs => _t('Specs', 'සවිස්තර', 'விவரக்குறிப்புகள்');
  String get reviews => _t('Reviews', 'සමාලෝචන', 'மதிப்புரைகள்');
  String get chat => _t('Chat', 'කතාබස', 'அரட்டை');
  String get verified => _t('Verified', 'සත්‍යාපිත', 'சரிபார்க்கப்பட்டது');
  String get weightUnit => _t('Weight/Unit', 'බර/ඒකක', 'எடை/அலகு');
  String get qtyAvailable =>
      _t('Qty Available', 'ලබා ගත හැකි ප.', 'கிடைக்கும் அளவு');
  String get deliveryIsland =>
      _t('Available islandwide', 'දිවයිනේ ඕනෑම තැන', 'தீவு முழுவதும்');
  String get noReviewsYet => _t('No reviews yet.\nBe the first!',
      'සමාලෝචන නොමැත.', 'இதுவரை மதிப்புரைகள் இல்லை.');
  String get verifiedReviews => _t(
      'verified reviews', 'සත්‍යාපිත සමාලෝචන', 'சரிபார்க்கப்பட்ட மதிப்புரைகள்');

  // ══════════════════════════════════════════════════════════════════════════
  // CART & PAYMENT
  // ══════════════════════════════════════════════════════════════════════════
  String get cart => _t('Cart', 'කූඩය', 'கூடை');
  String get items => _t('items', 'අයිතම', 'பொருட்கள்');
  String get promoCode =>
      _t('Enter promo code', 'ප්‍රවර්ධන කේතය', 'ப்ரோமோ குறியீடு');
  String get apply => _t('Apply', 'යොදන්න', 'பயன்படுத்து');
  String get subtotal => _t('Subtotal', 'උප එකතුව', 'உட்கொகை');
  String get delivery => _t('Delivery', 'බෙදාහැරීම', 'டெலிவரி');
  String get total => _t('Total', 'එකතුව', 'மொத்தம்');
  String get proceedToPayment =>
      _t('Proceed to Payment', 'ගෙවීමට ඉදිරියට', 'கட்டணம் செலுத்து');
  String get payment => _t('Payment', 'ගෙවීම', 'கட்டணம்');
  String get totalAmount => _t('Total Amount', 'මුළු මුදල', 'மொத்த தொகை');
  String get securedPayment =>
      _t('Secured Payment', 'ආරක්ෂිත ගෙවීම', 'பாதுகாப்பான கட்டணம்');
  String get selectPayMethod => _t(
      'Select Payment Method', 'ගෙවීම් ක්‍රමය', 'கட்டண முறை தேர்ந்தெடுக்கவும்');
  String get creditDebitCard =>
      _t('Credit / Debit Card', 'ණය/ඩෙබිට් කාඩ්', 'கடன்/டெபிட் கார்டு');
  String get bankTransfer =>
      _t('Bank Transfer', 'බැංකු හුවමාරුව', 'வங்கி பரிமாற்றம்');
  String get mobilePay => _t('Mobile Pay', 'ජංගම ගෙවීම', 'மொபைல் கட்டணம்');
  String get cashOnDelivery =>
      _t('Cash on Delivery', 'බෙදාහැරීමේදී', 'டெலிவரியில் பணம்');
  String get payBtn => _t('Pay', 'ගෙවන්න', 'கட்டண செலுத்து');
  String get cardNumber => _t('Card Number', 'කාඩ් අංකය', 'கார்டு எண்');
  String get cardHolder =>
      _t('Card Holder Name', 'කාඩ් හිමිකරු නම', 'கார்டு வைத்திருப்பவர் பெயர்');
  String get expiryDate => _t('Expiry Date', 'කල් ඉකුත්වීම', 'காலாவதி தேதி');
  String get saveCard => _t('Save card for future payments',
      'කාඩ් ගෙවීම් සඳහා සුරකින්', 'எதிர்கால கட்டணங்களுக்கு சேமி');
  String get paymentSuccess => _t('Payment Successful!', 'ගෙවීම සාර්ථකයි!',
      'கட்டணம் வெற்றிகரமாக முடிந்தது!');
  String get orderPlaced => _t('Your order has been placed.',
      'ඔබේ ඇණවුම ස්ථාන ගත කළා.', 'உங்கள் ஆர்டர் வைக்கப்பட்டது.');
  String get backToHome =>
      _t('Back to Home', 'ගෙදරට ආපසු', 'முகப்புக்கு திரும்பு');

  // ══════════════════════════════════════════════════════════════════════════
  // ORDERS
  // ══════════════════════════════════════════════════════════════════════════
  String get myOrders => _t('My Orders', 'මගේ ඇණවුම්', 'என் ஆர்டர்கள்');
  String get delivered => _t('Delivered', 'ලැබිණි', 'டெலிவரி ஆனது');
  String get inTransit => _t('In Transit', 'ගමනේ', 'போக்குவரத்தில்');
  String get processing => _t('Processing', 'සකසමින්', 'செயலாக்கம்');

  // ══════════════════════════════════════════════════════════════════════════
  // PROFILE
  // ══════════════════════════════════════════════════════════════════════════
  String get myProfile => _t('My Profile', 'මගේ පැතිකඩ', 'என் சுயவிவரம்');
  String get editProfile =>
      _t('Edit Profile', 'පැතිකඩ සංස්කරණය', 'சுயவிவரம் திருத்து');
  String get fullName => _t('Full Name', 'සම්පූර්ණ නම', 'முழு பெயர்');
  String get emailAddress =>
      _t('Email Address', 'විද්‍යුත් ලිපිනය', 'மின்னஞ்சல் முகவரி');
  String get phoneNumber => _t('Phone Number', 'දුරකථන අංකය', 'தொலைபேசி எண்');
  String get primaryCrop => _t('Primary Crop', 'ප්‍රධාන බෝගය', 'முதன்மை பயிர்');
  String get farmDetails =>
      _t('Farm Details', 'ගොවිපල විස්තර', 'பண்ணை விவரங்கள்');
  String get recentActivity =>
      _t('Recent Activity', 'මෑත ක්‍රියාකාරකම', 'சமீபத்திய செயல்கள்');
  String get account => _t('Account', 'ගිණුම', 'கணக்கு');
  String get transactionHistory =>
      _t('Transaction History', 'ගනුදෙනු ඉතිහාසය', 'பரிவர்த்தனை வரலாறு');
  String get myReviews => _t('My Reviews', 'මගේ සමාලෝචන', 'என் மதிப்புரைகள்');
  String get helpSupport =>
      _t('Help & Support', 'උදව් හා සහාය', 'உதவி மற்றும் ஆதரவு');
  String get privacyPolicy =>
      _t('Privacy Policy', 'පෞද්ගලිකත්ව ප.', 'தனியுரிமை கொள்கை');
  String get logout => _t('Logout', 'ඉවත් වන්න', 'வெளியேறு');
  String get logoutConfirm => _t('Are you sure you want to logout?',
      'ඔබ ඉවත් වීමට ඔව් ද?', 'வெளியேற விரும்புகிறீர்களா?');
  String get verifiedSeller => _t(
      'Verified Seller', 'සත්‍යාපිත විකුණුම්', 'சரிபார்க்கப்பட்ட விற்பனையாளர்');
  String get viewProfile =>
      _t('View Profile', 'පැතිකඩ බලන්න', 'சுயவிவரம் காண்');
  String get profileUpdated => _t('Profile updated successfully ✅',
      'පැතිකඩ යාවත්කාලීන කළා ✅', 'சுயவிவரம் புதுப்பிக்கப்பட்டது ✅');
  String get nameCannotBeEmpty => _t('Name cannot be empty',
      'නම හිස් විය නොහැක', 'பெயர் காலியாக இருக்க முடியாது');
  String get emailCannotChange => _t('Email Address (cannot change)',
      'ඊමේල් (වෙනස් කළ නොහැක)', 'மின்னஞ்சல் (மாற்ற முடியாது)');
  String get totalFarm => _t('Total Farm', 'ගොවිපල', 'மொத்த பண்ணை');
  String get seasons => _t('Seasons', 'සෘතු', 'பருவங்கள்');
  String get thisYear => _t('This Year', 'මෙ වසර', 'இந்த ஆண்டு');
  String get photoUploadSoon =>
      _t('Photo upload coming soon', 'ඡායාරූප ඉක්මනින්', 'புகைப்படம் விரைவில்');

  // ══════════════════════════════════════════════════════════════════════════
  // SETTINGS
  // ══════════════════════════════════════════════════════════════════════════
  String get settings => _t('Settings', 'සැකසුම්', 'அமைப்புகள்');
  String get notifications => _t('Notifications', 'දැනුම්දීම්', 'அறிவிப்புகள்');
  String get pushNotifications =>
      _t('Push Notifications', 'Push දැනුම්දීම්', 'Push அறிவிப்புகள்');
  String get pushNotifSub => _t('Receive app notifications',
      'යෙදුම් දැනුම් ලබන්න', 'ஆப் அறிவிப்புகள் பெறுக');
  String get priceAlerts =>
      _t('Price Alerts', 'මිල අනතුරු ඇඟවීම්', 'விலை எச்சரிக்கைகள்');
  String get priceAlertsSub => _t('Get notified on price changes',
      'මිල වෙනස් දැනගන්න', 'விலை மாற்றங்களை அறிக');
  String get weatherAlerts =>
      _t('Weather Alerts', 'කාලගුණ අනතුරු', 'வானிலை எச்சரிக்கைகள்');
  String get weatherAlertsSub =>
      _t('Rain & drought warnings', 'වැසි සහ නියං', 'மழை மற்றும் வறட்சி');
  String get pestWarnings =>
      _t('Pest Warnings', 'කෘමි අනතුරු ඇඟවීම්', 'பூச்சி எச்சரிக்கைகள்');
  String get pestWarningSub => _t('Early pest detection',
      'කෘමි මුල් හඳුනාගැනීම', 'முன்கூட்டிய பூச்சி கண்டறிதல்');
  String get preferences => _t('Preferences', 'මනාපාත', 'விருப்பத்தேர்வுகள்');
  String get language => _t('Language', 'භාෂාව', 'மொழி');
  String get units => _t('Units', 'ඒකක', 'அலகுகள்');
  String get darkMode => _t('Dark Mode', 'අඳුරු ප්‍රකාරය', 'இருண்ட பயன்முறை');
  String get darkModeSub =>
      _t('Switch to dark theme', 'අඳුරු තේමාව', 'இருண்ட தீம்');
  String get locationServices =>
      _t('Location Services', 'ස්ථාන සේවා', 'இருப்பிட சேவைகள்');
  String get locationSub => _t('Enable for nearby services', 'ආසන්න සේවා සඳහා',
      'அருகில் உள்ள சேவைகளுக்கு');
  String get cropSettings =>
      _t('Crop Settings', 'බෝග සැකසුම්', 'பயிர் அமைப்புகள்');
  String get myCropsLabel => _t('My Crops', 'මගේ බෝග', 'என் பயிர்கள்');
  String get myCropsSub => _t('Paddy, Corn', 'වී, බඩිරිඳු', 'நெல், சோளம்');
  String get farmAreas => _t('Farm Areas', 'ගොවිපල ප්‍රදේශ', 'பண்ணை பகுதிகள்');
  String get farmAreasSub =>
      _t('Manage your farm locations', 'ගොවිපල ස්ථාන', 'உங்கள் பண்ணை இடங்கள்');
  String get cropCalendar =>
      _t('Crop Calendar', 'බෝග දිනදර්ශනය', 'பயிர் நாட்காட்டி');
  String get cropCalendarSub =>
      _t('Set planting seasons', 'රෝපණ කාල', 'நடவு பருவங்கள்');
  String get accountSecurity => _t(
      'Account & Security', 'ගිණුම සහ ආරක්‍ෂාව', 'கணக்கு மற்றும் பாதுகாப்பு');
  String get changePassword =>
      _t('Change Password', 'මුරපදය වෙනස් කරන්න', 'கடவுச்சொல் மாற்று');
  String get updatePhone =>
      _t('Update Phone', 'දුරකථනය යාවත්කාලීන', 'தொலைபேசி புதுப்பி');
  String get verifyAccount =>
      _t('Verify Account', 'ගිණුම සත්‍යාපනය', 'கணக்கை சரிபார்');
  String get unverified =>
      _t('Unverified', 'සත්‍යාපිත නොවේ', 'சரிபார்க்கப்படவில்லை');
  String get deleteAccount =>
      _t('Delete Account', 'ගිණුම මකන්න', 'கணக்கை நீக்கு');
  String get supportInfo =>
      _t('Support & Info', 'සහාය සහ තොරතුරු', 'ஆதரவு மற்றும் தகவல்');
  String get helpCenter => _t('Help Center', 'උදව් මධ්‍යස්ථානය', 'உதவி மையம்');
  String get sendFeedback =>
      _t('Send Feedback', 'ප්‍රතිපෝෂণ යවන්න', 'கருத்து அனுப்பு');
  String get rateApp =>
      _t('Rate the App', 'යෙදුම ශ්‍රේණිගත', 'ஆப்பை மதிப்பிடு');
  String get aboutApp =>
      _t('About Grow Mate', 'Grow Mate ගැන', 'Grow Mate பற்றி');
  String get signOut => _t('Sign Out', 'ඉවත් වන්න', 'வெளியேறு');
  String get languageChanged =>
      _t('Language changed!', 'භාෂාව වෙනස් කළා!', 'மொழி மாற்றப்பட்டது!');

  // ── Language display names ─────────────────────────────────────────────
  String get langEnglish => _t('English', 'ඉංග්‍රීසි', 'ஆங்கிலம்');
  String get langSinhala => _t('Sinhala', 'සිංහල', 'சிங்களம்');
  String get langTamil => _t('Tamil', 'දෙමළ', 'தமிழ்');

  // ── Units options ──────────────────────────────────────────────────────
  String get unitMetric =>
      _t('Metric (kg, ha)', 'මෙට්‍රික් (කිලෝ, හෙ)', 'மெட்ரிக் (கிலோ, ஹெக்)');
  String get unitImperial =>
      _t('Imperial (lb, acre)', 'ඉම්පීරියල් (රාත්, අ)', 'இம்பீரியல் (பவுண்ட்)');

  // ── Onboarding ─────────────────────────────────────────────────────────
  String get skipBtn => _t('Skip', 'මඟ හරින්', 'தவிர்');
  String get nextBtn => _t('Next', 'ඊළඟ', 'அடுத்து');
  String get getStartedBtn => _t('Get Started', 'ආරම්භ කරන්න', 'தொடங்கு');
  String get onboard1Title => _t('Buy & Sell\nFarm Produce',
      'ගොවිතැන් නිෂ්පාදන\nකිනිිස් / ගෙවිිිල', 'பண்ணை உற்பத்தி\nவாங்கு / விற்');
  String get onboard2Title => _t('Fertilizers &\nChemicals',
      'පොහොර සහ\nකෘෂි රසායන', 'உரங்கள் மற்றும்\nவேதிப்பொருட்கள்');
  String get onboard3Title => _t('Trusted\nMarketplace',
      'විශ්වාසනීය\nවෙළඳ ස්ථානය', 'நம்பகமான\nசந்தை இடம்');
}

// ════════════════════════════════════════════════════════════════════════════
// LocalizedApp WRAPPER
// Usage: wrap your AgriMarketApp body with LocalizedApp
//
//   void main() => runApp(const LocalizedApp());
//
// ════════════════════════════════════════════════════════════════════════════

class LocalizedApp extends StatefulWidget {
  const LocalizedApp({super.key});
  @override
  State<LocalizedApp> createState() => _LocalizedAppState();
}

class _LocalizedAppState extends State<LocalizedApp> {
  @override
  void initState() {
    super.initState();
    AppLocale.instance.localeNotifier.addListener(_onLocaleChange);
  }

  @override
  void dispose() {
    AppLocale.instance.localeNotifier.removeListener(_onLocaleChange);
    super.dispose();
  }

  void _onLocaleChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grow Mate',
      debugShowCheckedModeBanner: false,
      locale: AppLocale.instance.locale,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
      ],
      supportedLocales: AppLocale.supportedLocales,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A5C34)),
        scaffoldBackgroundColor: const Color(0xFFF5F3EE),
        useMaterial3: true,
      ),
      home: const SettingsScreen(), // replace with your real home
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// STUB — remove when using real Session from main.dart
// ════════════════════════════════════════════════════════════════════════════

class _AppUser {
  final String name, email;
  const _AppUser({required this.name, required this.email});

  get phone => null;

  get cropType => null;

  get region => null;
}

class _Session {
  static const _AppUser user =
      _AppUser(name: 'Suresh Kumar', email: 'suresh@growmate.lk');
}

// Alias so SettingsScreen compiles standalone
typedef Session = _Session;
typedef AppUser = _AppUser;

// ════════════════════════════════════════════════════════════════════════════
// REDESIGNED SETTINGS SCREEN
// ════════════════════════════════════════════════════════════════════════════

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  bool _pushNotifications = true;
  bool _priceAlerts = true;
  bool _weatherAlerts = true;
  bool _pestAlerts = false;
  bool _darkMode = false;
  bool _locationServices = true;
  String _selectedUnit = 'metric';

  // Language state — mirrors AppLocale
  String get _currentLang => AppLocale.instance.locale.languageCode;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
    AppLocale.instance.localeNotifier.addListener(_onLocaleChange);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    AppLocale.instance.localeNotifier.removeListener(_onLocaleChange);
    super.dispose();
  }

  void _onLocaleChange() => setState(() {});

  void _changeLanguage(String code) {
    AppLocale.instance.setLocale(code);
    final l = AppL10n(code);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(l.languageChanged),
      backgroundColor: const Color(0xFF1A5C34),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ));
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFF1A5C34),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 1),
      ));

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final user = Session.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F0EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F3D22),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(children: [
          Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: const Color(0xFFCB8C00),
                  borderRadius: BorderRadius.circular(9)),
              child:
                  const Icon(Icons.eco_rounded, color: Colors.white, size: 17)),
          const SizedBox(width: 10),
          Text(l.settings,
              style:
                  const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        ]),
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ── Profile quick card ──────────────────────────────────────────
            _profileCard(l, user),
            const SizedBox(height: 24),

            // ── Language Selector ───────────────────────────────────────────
            _sectionHeader(l.language, '🌐'),
            const SizedBox(height: 10),
            _languageSelector(l),
            const SizedBox(height: 24),

            // ── Notifications ───────────────────────────────────────────────
            _sectionHeader(l.notifications, '🔔'),
            const SizedBox(height: 10),
            _settingsCard([
              _switchTile(
                  l.pushNotifications,
                  l.pushNotifSub,
                  _pushNotifications,
                  (v) => setState(() => _pushNotifications = v)),
              _divider(),
              _switchTile(l.priceAlerts, l.priceAlertsSub, _priceAlerts,
                  (v) => setState(() => _priceAlerts = v)),
              _divider(),
              _switchTile(l.weatherAlerts, l.weatherAlertsSub, _weatherAlerts,
                  (v) => setState(() => _weatherAlerts = v)),
              _divider(),
              _switchTile(l.pestWarnings, l.pestWarningSub, _pestAlerts,
                  (v) => setState(() => _pestAlerts = v)),
            ]),
            const SizedBox(height: 24),

            // ── Preferences ─────────────────────────────────────────────────
            _sectionHeader(l.preferences, '⚙️'),
            const SizedBox(height: 10),
            _settingsCard([
              _dropdownTile(
                  l.units,
                  _selectedUnit,
                  [('metric', l.unitMetric), ('imperial', l.unitImperial)],
                  (v) => setState(() => _selectedUnit = v!)),
              _divider(),
              _switchTile(l.darkMode, l.darkModeSub, _darkMode,
                  (v) => setState(() => _darkMode = v)),
              _divider(),
              _switchTile(l.locationServices, l.locationSub, _locationServices,
                  (v) => setState(() => _locationServices = v)),
            ]),
            const SizedBox(height: 24),

            // ── Crop Settings ───────────────────────────────────────────────
            _sectionHeader(l.cropSettings, '🌾'),
            const SizedBox(height: 10),
            _settingsCard([
              _navTile(Icons.grass_rounded, l.myCropsLabel, l.myCropsSub,
                  () => _snack(l.comingSoon)),
              _divider(),
              _navTile(Icons.map_outlined, l.farmAreas, l.farmAreasSub,
                  () => _snack(l.comingSoon)),
              _divider(),
              _navTile(Icons.schedule_rounded, l.cropCalendar,
                  l.cropCalendarSub, () => _snack(l.comingSoon)),
            ]),
            const SizedBox(height: 24),

            // ── Account & Security ──────────────────────────────────────────
            _sectionHeader(l.accountSecurity, '🔐'),
            const SizedBox(height: 10),
            _settingsCard([
              _navTile(Icons.lock_outline_rounded, l.changePassword, '',
                  () => _snack(l.comingSoon)),
              _divider(),
              _navTile(Icons.phone_outlined, l.updatePhone, '',
                  () => _snack(l.comingSoon)),
              _divider(),
              _navTile(Icons.verified_user_outlined, l.verifyAccount,
                  l.unverified, () => _snack(l.comingSoon)),
              _divider(),
              _navTile(Icons.delete_outline_rounded, l.deleteAccount, '',
                  () => _snack(l.comingSoon),
                  danger: true),
            ]),
            const SizedBox(height: 24),

            // ── Support & Info ──────────────────────────────────────────────
            _sectionHeader(l.supportInfo, 'ℹ️'),
            const SizedBox(height: 10),
            _settingsCard([
              _navTile(Icons.help_outline_rounded, l.helpCenter, '',
                  () => _snack(l.comingSoon)),
              _divider(),
              _navTile(Icons.feedback_outlined, l.sendFeedback, '',
                  () => _snack(l.comingSoon)),
              _divider(),
              _navTile(Icons.star_rate_outlined, l.rateApp, '',
                  () => _snack(l.comingSoon)),
              _divider(),
              _navTile(Icons.info_outline_rounded, l.aboutApp, 'v1.0.0',
                  () => _snack(l.comingSoon)),
            ]),
            const SizedBox(height: 28),

            // ── Sign Out ────────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: Row(children: [
                        const Icon(Icons.logout_rounded,
                            color: Colors.red, size: 22),
                        const SizedBox(width: 8),
                        Text(l.logout,
                            style: const TextStyle(fontWeight: FontWeight.w800))
                      ]),
                      content: Text(l.logoutConfirm),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(l.cancel,
                                style: const TextStyle(color: Colors.grey))),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Text(l.logout,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  );
                  if (ok == true && mounted) {
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  }
                },
                icon: const Icon(Icons.logout_rounded,
                    color: Colors.red, size: 20),
                label: Text(l.signOut,
                    style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 36),
          ]),
        ),
      ),
    );
  }

  // ── Profile card ───────────────────────────────────────────────────────────
  Widget _profileCard(AppL10n l, dynamic user) {
    final initials = (user?.name?.isNotEmpty == true)
        ? (user!.name as String)
            .trim()
            .split(' ')
            .map((w) => w[0])
            .take(2)
            .join()
            .toUpperCase()
        : 'FK';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F3D22), Color(0xFF1A5C34), Color(0xFF267A46)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF1A5C34).withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6))
        ],
      ),
      child: Row(children: [
        Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                color: const Color(0xFFCB8C00),
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.white.withOpacity(0.3), width: 2)),
            child: Center(
                child: Text(initials,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18)))),
        const SizedBox(width: 14),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(user?.name ?? 'Farmer',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16)),
          const SizedBox(height: 2),
          Text(user?.email ?? '',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.65), fontSize: 12)),
          const SizedBox(height: 6),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(AppL10n.of(context).verifiedSeller,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600))),
        ])),
        GestureDetector(
          onTap: () => _snack('Opening profile...'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
                color: const Color(0xFFCB8C00),
                borderRadius: BorderRadius.circular(12)),
            child: Text(AppL10n.of(context).edit,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13)),
          ),
        ),
      ]),
    );
  }

  // ── Language selector — 3 cards ────────────────────────────────────────────
  Widget _languageSelector(AppL10n l) {
    final langs = [
      {
        'code': 'en',
        'label': l.langEnglish,
        'native': 'English',
        'flag': '🇬🇧'
      },
      {'code': 'si', 'label': l.langSinhala, 'native': 'සිංහල', 'flag': '🇱🇰'},
      {'code': 'ta', 'label': l.langTamil, 'native': 'தமிழ்', 'flag': '🇮🇳'},
    ];

    return Row(
        children: langs.map((lang) {
      final code = lang['code'] as String;
      final selected = _currentLang == code;
      return Expanded(
          child: GestureDetector(
        onTap: () => _changeLanguage(code),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF1A5C34) : const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  selected ? const Color(0xFF1A5C34) : const Color(0xFFDDD8CF),
              width: selected ? 2 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                        color: const Color(0xFF1A5C34).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ]
                : [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04), blurRadius: 8)
                  ],
          ),
          child: Column(children: [
            Text(lang['flag'] as String, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(lang['native'] as String,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: selected ? Colors.white : const Color(0xFF1A1A1A),
                    height: 1.1)),
            const SizedBox(height: 3),
            Text(lang['label'] as String,
                style: TextStyle(
                    fontSize: 10.5,
                    color: selected
                        ? Colors.white.withOpacity(0.8)
                        : const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? Colors.white : Colors.transparent,
                border: Border.all(
                    color: selected ? Colors.white : const Color(0xFFDDD8CF),
                    width: 2),
              ),
              child: selected
                  ? const Icon(Icons.check_rounded,
                      size: 14, color: Color(0xFF1A5C34))
                  : null,
            ),
          ]),
        ),
      ));
    }).toList());
  }

  // ── Section header ─────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, String emoji) {
    return Row(children: [
      Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF1A5C34), Color(0xFF267A46)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 10),
      Text('$emoji  $title',
          style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: Color(0xFF0F3D22),
              letterSpacing: -0.2)),
    ]);
  }

  // ── Card wrapper ───────────────────────────────────────────────────────────
  Widget _settingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAE5DC)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(children: children),
    );
  }

  // ── Switch tile ────────────────────────────────────────────────────────────
  Widget _switchTile(
      String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF1A1A1A))),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(subtitle,
                style:
                    const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11.5))
          ],
        ])),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: const Color(0xFF1A5C34),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFDDD8CF),
        ),
      ]),
    );
  }

  // ── Dropdown tile ──────────────────────────────────────────────────────────
  Widget _dropdownTile(String title, String value, List<(String, String)> items,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF1A1A1A)))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              color: const Color(0xFFE8F5ED),
              borderRadius: BorderRadius.circular(10)),
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
            value: value,
            isDense: true,
            style: const TextStyle(
                color: Color(0xFF1A5C34),
                fontWeight: FontWeight.w700,
                fontSize: 13),
            icon: const Icon(Icons.expand_more_rounded,
                color: Color(0xFF1A5C34), size: 18),
            items: items
                .map((i) => DropdownMenuItem(value: i.$1, child: Text(i.$2)))
                .toList(),
            onChanged: onChanged,
          )),
        ),
      ]),
    );
  }

  // ── Nav tile ───────────────────────────────────────────────────────────────
  Widget _navTile(IconData icon, String title, String value, VoidCallback onTap,
      {bool danger = false}) {
    final color = danger ? Colors.red : const Color(0xFF1A5C34);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 19)),
          const SizedBox(width: 12),
          Expanded(
              child: Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: danger ? Colors.red : const Color(0xFF1A1A1A)))),
          if (value.isNotEmpty) ...[
            Text(value,
                style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12)),
            const SizedBox(width: 4),
          ],
          Icon(Icons.arrow_forward_ios_rounded,
              color: const Color(0xFFDDD8CF), size: 13),
        ]),
      ),
    );
  }

  Widget _divider() => const Divider(
      height: 1, indent: 16, endIndent: 16, color: Color(0xFFF0EDE8));
}
