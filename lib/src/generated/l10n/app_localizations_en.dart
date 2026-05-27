// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Card Storage';

  @override
  String get navHome => 'Home';

  @override
  String get navSettings => 'Settings';

  @override
  String get createCardTitle => 'Create Card';

  @override
  String get editCardTitle => 'Edit Card';

  @override
  String get viewCardTitle => 'View Card';

  @override
  String get scanBarcodeTitle => 'Scan Barcode';

  @override
  String get cardListTitle => 'Card List';

  @override
  String get save => 'Save';

  @override
  String get saving => 'Saving...';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get cardNameLabel => 'Card Name';

  @override
  String get cardNumberLabel => 'Card Number';

  @override
  String get barcodeLabel => 'Barcode';

  @override
  String get cardNameRequired => 'Enter card name';

  @override
  String get barcodeRequired => 'Enter barcode';

  @override
  String barcodeTooShort(int min) {
    return 'Barcode must be at least $min characters';
  }

  @override
  String barcodeTooLong(int max) {
    return 'Barcode must be no more than $max characters';
  }

  @override
  String get barcodeAlreadyExists => 'A card with this barcode already exists';

  @override
  String get scanBarcode => 'Scan barcode';

  @override
  String get cardSaved => 'Card saved successfully';

  @override
  String get editCardAction => 'Edit Card';

  @override
  String get deleteCard => 'Delete Card';

  @override
  String get deleteCardQuestion => 'Delete card?';

  @override
  String get actionCannotBeUndone => 'This action cannot be undone.';

  @override
  String get cardNotFound => 'Card not found';

  @override
  String get backToCardList => 'Back to card list';

  @override
  String get copied => 'Copied';

  @override
  String get barcodeRenderError => 'Failed to render barcode';

  @override
  String get searchByCardName => 'Search by card name';

  @override
  String loadCardsError(String error) {
    return 'Failed to load cards: $error';
  }

  @override
  String get noCardsYet => 'No cards yet';

  @override
  String get noCardsFound => 'No cards found';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get data => 'Data';

  @override
  String get exportCards => 'Export Cards';

  @override
  String get exportCardsSubtitle => 'Save all cards to a JSON file';

  @override
  String get importCards => 'Import Cards';

  @override
  String get importCardsSubtitle => 'Load cards from a JSON file';

  @override
  String get noCardsToExport => 'No cards to export';

  @override
  String cardsExported(int count) {
    return 'Cards exported: $count';
  }

  @override
  String exportError(String error) {
    return 'Export error: $error';
  }

  @override
  String get saveCardsDialogTitle => 'Save Cards';

  @override
  String get selectCardsFile => 'Select cards file';

  @override
  String get fileHasNoCards => 'File contains no cards';

  @override
  String cardsImported(int count) {
    return 'Cards imported: $count';
  }

  @override
  String get invalidFileFormat => 'Invalid file format';

  @override
  String importError(String error) {
    return 'Import error: $error';
  }

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get scanFromGalleryTooltip => 'Scan from gallery';

  @override
  String get toggleFlashTooltip => 'Toggle flash';

  @override
  String get scanNotSupported =>
      'Scanning is supported on Android and iOS only.';

  @override
  String get noCameraFound => 'No camera found on this device.';

  @override
  String get scannerInitError => 'Failed to initialize scanner.';

  @override
  String get flashToggleError => 'Failed to toggle flash.';

  @override
  String get noBarcodeInImage => 'No barcode found in the selected image.';

  @override
  String get readBarcodeFromImageError => 'Failed to read barcode from image.';

  @override
  String get cameraAccessDenied => 'Camera access denied.';

  @override
  String get cameraAccessDeniedSettings =>
      'Camera access denied. Allow it in device settings.';

  @override
  String get cameraAccessRestricted =>
      'Camera access is restricted on this device.';

  @override
  String cameraOpenError(String description) {
    return 'Failed to open camera: $description';
  }

  @override
  String get cameraInitError => 'Failed to initialize camera.';

  @override
  String get scanInstruction =>
      'Point the camera at the card barcode or select an image from the gallery';

  @override
  String get freeLineOne => 'Free line 1';

  @override
  String get freeLineTwo => 'Free line 2';
}
