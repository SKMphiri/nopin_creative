import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nopin_creative/core/constants/assets.dart';
import 'package:nopin_creative/features/profile/presentation/views/check_id_document.dart';

class CaptureDocument extends StatefulWidget {
  const CaptureDocument({super.key, required this.isProfilePicture});

  final bool isProfilePicture;

  @override
  State<CaptureDocument> createState() => _CaptureDocumentState();
}

class _CaptureDocumentState extends State<CaptureDocument> {
  CameraController? _controller;
  late Future<void> _initializeCameraFuture;
  bool _isTakingPicture = false;
  static const _guideBoxWidth = 300.0;
  static const _guideBoxHeight = 200.0;

  @override
  void initState() {
    super.initState();
    _initializeCameraFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw CameraException('NoCamera', 'No cameras available');
      }

      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == (widget.isProfilePicture ? CameraLensDirection.front : CameraLensDirection.back),
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      await _controller!.setFlashMode(FlashMode.off);
    } catch (e) {
      print('Error initializing camera: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isTakingPicture) {
      return;
    }

    setState(() => _isTakingPicture = true);
    try {
      final XFile image = await _controller!.takePicture();
      if (mounted) {
        final result = await showModalBottomSheet<String?>(
          isScrollControlled: true,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          builder: (context) => CheckCapturedDocument(imagePath: image.path, isProfilePicture:  widget.isProfilePicture),
        );

        // If result is not null, it means user confirmed the image
        if (result != null && mounted) {
          Navigator.pop(context, result); // Return the result to the caller
        }
        // Don't pop the CaptureDocument yet - let CheckCapturedDocument handle navigation
      }
    } catch (e) {
      print('Error taking picture: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error capturing image: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isTakingPicture = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: FutureBuilder<void>(
              future: _initializeCameraFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Camera Error: ${snapshot.error}',
                        style: GoogleFonts.poppins(color: Colors.red),
                      ),
                    );
                  }
                  return _buildCameraPreview();
                }
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideOverlay() {
    return Stack(
      children: [

        Center(
          child: SizedBox(
            width: widget.isProfilePicture ? 300 : _guideBoxWidth,
            height: widget.isProfilePicture ? 300 : _guideBoxHeight,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(widget.isProfilePicture ? 300 : 20),
                  ),
                ),
                const Positioned.fill(
                    child: Image(image: AssetImage(AppIcons.idCard)))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Expanded(
            child: Text(
              "Escolher o documento",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 40), // Balance the header
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: CameraPreview(_controller!),
        ),
        // Semi-transparent overlay with cutout
        _buildGuideOverlay(),
        // Capture button
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: ElevatedButton(
            onPressed: _isTakingPicture ? null : _takePicture,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: _isTakingPicture
                ? const CircularProgressIndicator(color: Colors.black)
                : Text(
                    "Capturar",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
