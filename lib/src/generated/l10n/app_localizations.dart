import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Card Storage'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @createCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Card'**
  String get createCardTitle;

  /// No description provided for @editCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Card'**
  String get editCardTitle;

  /// No description provided for @viewCardTitle.
  ///
  /// In en, this message translates to:
  /// **'View Card'**
  String get viewCardTitle;

  /// No description provided for @scanBarcodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scanBarcodeTitle;

  /// No description provided for @cardListTitle.
  ///
  /// In en, this message translates to:
  /// **'Card List'**
  String get cardListTitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cardNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Card Name'**
  String get cardNameLabel;

  /// No description provided for @cardNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumberLabel;

  /// No description provided for @barcodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcodeLabel;

  /// No description provided for @cardNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter card name'**
  String get cardNameRequired;

  /// No description provided for @barcodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter barcode'**
  String get barcodeRequired;

  /// No description provided for @barcodeTooShort.
  ///
  /// In en, this message translates to:
  /// **'Barcode must be at least {min} characters'**
  String barcodeTooShort(int min);

  /// No description provided for @barcodeTooLong.
  ///
  /// In en, this message translates to:
  /// **'Barcode must be no more than {max} characters'**
  String barcodeTooLong(int max);

  /// No description provided for @barcodeAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'A card with this barcode already exists'**
  String get barcodeAlreadyExists;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get scanBarcode;

  /// No description provided for @cardSaved.
  ///
  /// In en, this message translates to:
  /// **'Card saved successfully'**
  String get cardSaved;

  /// No description provided for @editCardAction.
  ///
  /// In en, this message translates to:
  /// **'Edit Card'**
  String get editCardAction;

  /// No description provided for @deleteCard.
  ///
  /// In en, this message translates to:
  /// **'Delete Card'**
  String get deleteCard;

  /// No description provided for @deleteCardQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete card?'**
  String get deleteCardQuestion;

  /// No description provided for @actionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get actionCannotBeUndone;

  /// No description provided for @cardNotFound.
  ///
  /// In en, this message translates to:
  /// **'Card not found'**
  String get cardNotFound;

  /// No description provided for @backToCardList.
  ///
  /// In en, this message translates to:
  /// **'Back to card list'**
  String get backToCardList;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @barcodeRenderError.
  ///
  /// In en, this message translates to:
  /// **'Failed to render barcode'**
  String get barcodeRenderError;

  /// No description provided for @searchByCardName.
  ///
  /// In en, this message translates to:
  /// **'Search by card name'**
  String get searchByCardName;

  /// No description provided for @loadCardsError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cards: {error}'**
  String loadCardsError(String error);

  /// No description provided for @noCardsYet.
  ///
  /// In en, this message translates to:
  /// **'No cards yet'**
  String get noCardsYet;

  /// No description provided for @noCardsFound.
  ///
  /// In en, this message translates to:
  /// **'No cards found'**
  String get noCardsFound;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @exportCards.
  ///
  /// In en, this message translates to:
  /// **'Export Cards'**
  String get exportCards;

  /// No description provided for @exportCardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save all cards to a JSON file'**
  String get exportCardsSubtitle;

  /// No description provided for @importCards.
  ///
  /// In en, this message translates to:
  /// **'Import Cards'**
  String get importCards;

  /// No description provided for @importCardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Load cards from a JSON file'**
  String get importCardsSubtitle;

  /// No description provided for @noCardsToExport.
  ///
  /// In en, this message translates to:
  /// **'No cards to export'**
  String get noCardsToExport;

  /// No description provided for @cardsExported.
  ///
  /// In en, this message translates to:
  /// **'Cards exported: {count}'**
  String cardsExported(int count);

  /// No description provided for @exportError.
  ///
  /// In en, this message translates to:
  /// **'Export error: {error}'**
  String exportError(String error);

  /// No description provided for @saveCardsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Save Cards'**
  String get saveCardsDialogTitle;

  /// No description provided for @selectCardsFile.
  ///
  /// In en, this message translates to:
  /// **'Select cards file'**
  String get selectCardsFile;

  /// No description provided for @fileHasNoCards.
  ///
  /// In en, this message translates to:
  /// **'File contains no cards'**
  String get fileHasNoCards;

  /// No description provided for @cardsImported.
  ///
  /// In en, this message translates to:
  /// **'Cards imported: {count}'**
  String cardsImported(int count);

  /// No description provided for @invalidFileFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid file format'**
  String get invalidFileFormat;

  /// No description provided for @importError.
  ///
  /// In en, this message translates to:
  /// **'Import error: {error}'**
  String importError(String error);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @scanFromGalleryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Scan from gallery'**
  String get scanFromGalleryTooltip;

  /// No description provided for @toggleFlashTooltip.
  ///
  /// In en, this message translates to:
  /// **'Toggle flash'**
  String get toggleFlashTooltip;

  /// No description provided for @scanNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Scanning is supported on Android and iOS only.'**
  String get scanNotSupported;

  /// No description provided for @noCameraFound.
  ///
  /// In en, this message translates to:
  /// **'No camera found on this device.'**
  String get noCameraFound;

  /// No description provided for @scannerInitError.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize scanner.'**
  String get scannerInitError;

  /// No description provided for @flashToggleError.
  ///
  /// In en, this message translates to:
  /// **'Failed to toggle flash.'**
  String get flashToggleError;

  /// No description provided for @noBarcodeInImage.
  ///
  /// In en, this message translates to:
  /// **'No barcode found in the selected image.'**
  String get noBarcodeInImage;

  /// No description provided for @readBarcodeFromImageError.
  ///
  /// In en, this message translates to:
  /// **'Failed to read barcode from image.'**
  String get readBarcodeFromImageError;

  /// No description provided for @cameraAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera access denied.'**
  String get cameraAccessDenied;

  /// No description provided for @cameraAccessDeniedSettings.
  ///
  /// In en, this message translates to:
  /// **'Camera access denied. Allow it in device settings.'**
  String get cameraAccessDeniedSettings;

  /// No description provided for @cameraAccessRestricted.
  ///
  /// In en, this message translates to:
  /// **'Camera access is restricted on this device.'**
  String get cameraAccessRestricted;

  /// No description provided for @cameraOpenError.
  ///
  /// In en, this message translates to:
  /// **'Failed to open camera: {description}'**
  String cameraOpenError(String description);

  /// No description provided for @cameraInitError.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize camera.'**
  String get cameraInitError;

  /// No description provided for @scanInstruction.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the card barcode or select an image from the gallery'**
  String get scanInstruction;

  /// No description provided for @freeLineOne.
  ///
  /// In en, this message translates to:
  /// **'Free line 1'**
  String get freeLineOne;

  /// No description provided for @freeLineTwo.
  ///
  /// In en, this message translates to:
  /// **'Free line 2'**
  String get freeLineTwo;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
