// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Card Storage';

  @override
  String get navHome => 'Главная';

  @override
  String get navSettings => 'Настройки';

  @override
  String get createCardTitle => 'Создание карты';

  @override
  String get editCardTitle => 'Редактирование карты';

  @override
  String get viewCardTitle => 'Просмотр карты';

  @override
  String get scanBarcodeTitle => 'Сканирование barcode';

  @override
  String get cardListTitle => 'Список карт';

  @override
  String get save => 'Сохранить';

  @override
  String get saving => 'Сохранение...';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get cardNameLabel => 'Название карты';

  @override
  String get cardNumberLabel => 'Номер карты';

  @override
  String get barcodeLabel => 'Штрихкод';

  @override
  String get cardNameRequired => 'Введите название карты';

  @override
  String get barcodeRequired => 'Введите штрихкод';

  @override
  String barcodeTooShort(int min) {
    return 'Штрихкод должен содержать минимум $min символов';
  }

  @override
  String barcodeTooLong(int max) {
    return 'Штрихкод должен содержать не больше $max символов';
  }

  @override
  String get barcodeAlreadyExists => 'Карта с таким штрихкодом уже существует';

  @override
  String get scanBarcode => 'Сканировать barcode';

  @override
  String get cardSaved => 'Карта успешно сохранена';

  @override
  String get editCardAction => 'Редактировать карту';

  @override
  String get deleteCard => 'Удалить карту';

  @override
  String get deleteCardQuestion => 'Удалить карту?';

  @override
  String get actionCannotBeUndone => 'Это действие нельзя отменить.';

  @override
  String get cardNotFound => 'Карта не найдена';

  @override
  String get backToCardList => 'К списку карт';

  @override
  String get copied => 'Скопировано';

  @override
  String get barcodeRenderError => 'Не удалось построить barcode';

  @override
  String get searchByCardName => 'Поиск по названию карты';

  @override
  String loadCardsError(String error) {
    return 'Не удалось загрузить карты: $error';
  }

  @override
  String get noCardsYet => 'Карт пока нет';

  @override
  String get noCardsFound => 'Карты не найдены';

  @override
  String get appearance => 'Оформление';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get data => 'Данные';

  @override
  String get exportCards => 'Выгрузить карты';

  @override
  String get exportCardsSubtitle => 'Сохранить все карты в JSON-файл';

  @override
  String get importCards => 'Импортировать карты';

  @override
  String get importCardsSubtitle => 'Загрузить карты из JSON-файла';

  @override
  String get noCardsToExport => 'Нет карт для выгрузки';

  @override
  String cardsExported(int count) {
    return 'Выгружено карт: $count';
  }

  @override
  String exportError(String error) {
    return 'Ошибка выгрузки: $error';
  }

  @override
  String get saveCardsDialogTitle => 'Сохранить карты';

  @override
  String get selectCardsFile => 'Выбрать файл карт';

  @override
  String get fileHasNoCards => 'Файл не содержит карт';

  @override
  String cardsImported(int count) {
    return 'Импортировано карт: $count';
  }

  @override
  String get invalidFileFormat => 'Неверный формат файла';

  @override
  String importError(String error) {
    return 'Ошибка импорта: $error';
  }

  @override
  String get language => 'Язык';

  @override
  String get languageSystem => 'Системный';

  @override
  String get scanFromGalleryTooltip => 'Сканировать из галереи';

  @override
  String get toggleFlashTooltip => 'Переключить вспышку';

  @override
  String get scanNotSupported =>
      'Сканирование поддерживается только на Android и iOS.';

  @override
  String get noCameraFound => 'Камера на устройстве не найдена.';

  @override
  String get scannerInitError => 'Не удалось инициализировать сканер.';

  @override
  String get flashToggleError => 'Не удалось переключить вспышку.';

  @override
  String get noBarcodeInImage => 'На выбранном изображении barcode не найден.';

  @override
  String get readBarcodeFromImageError =>
      'Не удалось считать barcode с изображения.';

  @override
  String get cameraAccessDenied => 'Доступ к камере запрещён.';

  @override
  String get cameraAccessDeniedSettings =>
      'Доступ к камере запрещён. Разрешите его в настройках устройства.';

  @override
  String get cameraAccessRestricted =>
      'Доступ к камере ограничен на этом устройстве.';

  @override
  String cameraOpenError(String description) {
    return 'Не удалось открыть камеру: $description';
  }

  @override
  String get cameraInitError => 'Не удалось инициализировать камеру.';

  @override
  String get scanInstruction =>
      'Наведите камеру на barcode карты или выберите изображение из галереи';

  @override
  String get freeLineOne => 'Свободная строка 1';

  @override
  String get freeLineTwo => 'Свободная строка 2';
}
