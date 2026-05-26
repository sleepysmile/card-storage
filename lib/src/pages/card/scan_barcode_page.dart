import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ScanBarcodePage extends StatefulWidget {
  const ScanBarcodePage({super.key});

  @override
  State<ScanBarcodePage> createState() => _ScanBarcodePageState();
}

class _ScanBarcodePageState extends State<ScanBarcodePage>
    with WidgetsBindingObserver {
  static const _orientations = <DeviceOrientation, int>{
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  final ImagePicker _imagePicker = ImagePicker();

  CameraController? _cameraController;
  bool _isInitializing = true;
  bool _isProcessing = false;
  bool _canProcess = true;
  bool _isFlashOn = false;
  bool _isPickingImage = false;
  String? _errorMessage;

  bool get _isSupportedPlatform {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeScanner();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _canProcess = false;
    _disposeCameraController();
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _disposeCameraController();
    } else if (state == AppLifecycleState.resumed && !_isPickingImage) {
      _restartCameraIfNeeded();
    }
  }

  Future<void> _initializeScanner() async {
    if (!_isSupportedPlatform) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _errorMessage =
              'Сканирование поддерживается только на Android и iOS.';
        });
      }
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _isInitializing = false;
          _errorMessage = 'Камера на устройстве не найдена.';
        });
        return;
      }

      final camera = cameras.firstWhere(
        (description) => description.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      await _disposeCameraController();

      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: defaultTargetPlatform == TargetPlatform.iOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.nv21,
      );

      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);
      await controller.startImageStream(_processCameraImage);

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
        _isInitializing = false;
        _isFlashOn = false;
        _errorMessage = null;
      });
    } on CameraException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isInitializing = false;
        _errorMessage = _cameraErrorMessage(error);
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isInitializing = false;
        _errorMessage = 'Не удалось инициализировать сканер.';
      });
    }
  }

  Future<void> _disposeCameraController() async {
    final controller = _cameraController;

    if (mounted) {
      setState(() {
        _cameraController = null;
        _isFlashOn = false;
      });
    } else {
      _cameraController = null;
      _isFlashOn = false;
    }

    if (controller == null) {
      return;
    }

    try {
      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
    } on CameraException catch (_) {
      // The controller may already be stopping/disposed during lifecycle changes.
    }

    try {
      await controller.dispose();
    } on CameraException catch (_) {
      // Ignore duplicate dispose attempts caused by rapid lifecycle transitions.
    }
  }

  Future<void> _restartCameraIfNeeded() async {
    if (!_canProcess || _isPickingImage) {
      return;
    }

    final controller = _cameraController;
    if (controller != null && controller.value.isInitialized) {
      return;
    }

    if (mounted) {
      setState(() {
        _isInitializing = true;
        _errorMessage = null;
      });
    }

    await _initializeScanner();
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (!_canProcess || _isProcessing) {
      return;
    }

    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) {
      return;
    }

    _isProcessing = true;

    try {
      final barcodes = await _barcodeScanner.processImage(inputImage);
      if (barcodes.isEmpty || !mounted) {
        return;
      }

      await _finishScanning(barcodes);
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _toggleFlash() async {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    final nextFlashMode = _isFlashOn ? FlashMode.off : FlashMode.torch;

    try {
      await controller.setFlashMode(nextFlashMode);

      if (!mounted) {
        return;
      }

      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } on CameraException catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось переключить вспышку.')),
      );
    }
  }

  Future<void> _scanFromGallery() async {
    if (_isProcessing || _isPickingImage) {
      return;
    }

    try {
      _isPickingImage = true;
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (!mounted) {
        return;
      }

      if (image == null) {
        await _restartCameraIfNeeded();
        return;
      }

      setState(() {
        _isProcessing = true;
      });

      final inputImage = InputImage.fromFilePath(image.path);
      final barcodes = await _barcodeScanner.processImage(inputImage);

      if (!mounted) {
        return;
      }

      if (barcodes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('На выбранном изображении barcode не найден.'),
          ),
        );
        return;
      }

      await _finishScanning(barcodes);
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось считать barcode с изображения.'),
        ),
      );
    } finally {
      _isPickingImage = false;

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }

      await _restartCameraIfNeeded();
    }
  }

  Future<void> _finishScanning(List<Barcode> barcodes) async {
    final barcode = barcodes.firstWhere(
      (item) => (item.rawValue ?? '').isNotEmpty,
      orElse: () => barcodes.first,
    );
    final value = barcode.rawValue ?? barcode.displayValue;

    if (value == null || value.isEmpty) {
      return;
    }

    _canProcess = false;
    await _disposeCameraController();

    if (!mounted) {
      return;
    }

    context.pop(value);
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final controller = _cameraController;
    if (controller == null) {
      return null;
    }

    final rotation = _inputImageRotationFromCamera(controller);
    if (rotation == null || image.planes.isEmpty) {
      return null;
    }

    final format = defaultTargetPlatform == TargetPlatform.iOS
        ? InputImageFormat.bgra8888
        : InputImageFormat.nv21;

    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  InputImageRotation? _inputImageRotationFromCamera(
    CameraController controller,
  ) {
    final camera = controller.description;
    final sensorOrientation = camera.sensorOrientation;

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return InputImageRotationValue.fromRawValue(sensorOrientation);
    }

    final deviceOrientation = controller.value.deviceOrientation;
    final rotationCompensation = _orientations[deviceOrientation];
    if (rotationCompensation == null) {
      return null;
    }

    final adjustedRotation = camera.lensDirection == CameraLensDirection.front
        ? (sensorOrientation + rotationCompensation) % 360
        : (sensorOrientation - rotationCompensation + 360) % 360;

    return InputImageRotationValue.fromRawValue(adjustedRotation);
  }

  String _cameraErrorMessage(CameraException error) {
    switch (error.code) {
      case 'CameraAccessDenied':
        return 'Доступ к камере запрещён.';
      case 'CameraAccessDeniedWithoutPrompt':
        return 'Доступ к камере запрещён. Разрешите его в настройках устройства.';
      case 'CameraAccessRestricted':
        return 'Доступ к камере ограничен на этом устройстве.';
      default:
        return 'Не удалось открыть камеру: ${error.description ?? error.code}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _cameraController;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Сканирование barcode'),
        actions: [
          IconButton(
            onPressed: _isInitializing ? null : _scanFromGallery,
            icon: const Icon(Icons.photo_library_outlined),
            tooltip: 'Сканировать из галереи',
          ),
          IconButton(
            onPressed: _isInitializing ? null : _toggleFlash,
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            tooltip: 'Переключить вспышку',
          ),
        ],
      ),
      body: _isInitializing
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_errorMessage!, textAlign: TextAlign.center),
              ),
            )
          : controller == null || !controller.value.isInitialized
          ? const Center(child: Text('Не удалось инициализировать камеру.'))
          : Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(controller),
                IgnorePointer(
                  child: Center(
                    child: Container(
                      width: 340,
                      height: 230,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 24,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Наведите камеру на barcode карты или выберите изображение из галереи',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
