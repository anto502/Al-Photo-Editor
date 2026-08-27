import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AIPhotoEditorApp());
}

// ============================================================
// APP
// ============================================================

class AIPhotoEditorApp extends StatelessWidget {
  const AIPhotoEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Photo Editor',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF09090D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5CF6),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 100,
      );

      if (picked == null || !mounted) {
        return;
      }

      final file = File(picked.path);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditorScreen(file: file),
        ),
      );
    } catch (e) {
      _showMessage('Could not open photo.');
    }
  }

  void _showMessage(String text) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17171E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Choose a Photo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 22),

                _PickerOption(
                  icon: Icons.photo_library_rounded,
                  title: 'Photo Library',
                  subtitle: 'Choose an existing photo',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.gallery);
                  },
                ),

                const SizedBox(height: 10),

                _PickerOption(
                  icon: Icons.camera_alt_rounded,
                  title: 'Camera',
                  subtitle: 'Take a new photo',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF8B5CF6),
                          Color(0xFFEC4899),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Text(
                      'AI Photo Editor',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      _showMessage('Settings coming soon.');
                    },
                    icon: const Icon(
                      Icons.settings_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 55),

              const Text(
                'Create something\namazing.',
                style: TextStyle(
                  fontSize: 40,
                  height: 1.04,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Edit your photos with powerful tools.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.55),
                ),
              ),

              const SizedBox(height: 35),

              // FEATURE CARDS
              Row(
                children: [
                  Expanded(
                    child: _FeatureCard(
                      icon: Icons.auto_awesome_rounded,
                      title: 'AI Enhance',
                      subtitle: 'One tap enhance',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _FeatureCard(
                      icon: Icons.layers_clear_rounded,
                      title: 'Remove BG',
                      subtitle: 'Coming soon',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // CHOOSE PHOTO
              SizedBox(
                width: double.infinity,
                height: 62,
                child: FilledButton.icon(
                  onPressed: _openPicker,
                  icon: const Icon(
                    Icons.add_photo_alternate_rounded,
                  ),
                  label: const Text(
                    'Choose a Photo',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Center(
                child: Text(
                  'Your photos stay on your device.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.35),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PICKER OPTION
// ============================================================

class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PickerOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF22222B),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.18),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFA78BFA),
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.45),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// FEATURE CARD
// ============================================================

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF15151C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 28,
            color: const Color(0xFFA78BFA),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.42),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EDITOR SCREEN
// ============================================================

class EditorScreen extends StatefulWidget {
  final File file;

  const EditorScreen({
    super.key,
    required this.file,
  });

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

// ============================================================
// EDITOR HISTORY STATE
// ============================================================

class _EditHistory {
  final double brightness;
  final double contrast;
  final double saturation;
  final int filter;
  final int rotation;

  const _EditHistory({
    required this.brightness,
    required this.contrast,
    required this.saturation,
    required this.filter,
    required this.rotation,
  });
}

// ============================================================
// EDITOR STATE
// ============================================================

class _EditorScreenState extends State<EditorScreen> {
  final GlobalKey _previewKey = GlobalKey();

  double brightness = 0;
  double contrast = 1;
  double saturation = 1;

  int filter = 0;
  int rotation = 0;

  final List<_EditHistory> _history = [];

  // ----------------------------------------------------------
  // SAVE HISTORY
  // ----------------------------------------------------------

  void _saveHistory() {
    _history.add(
      _EditHistory(
        brightness: brightness,
        contrast: contrast,
        saturation: saturation,
        filter: filter,
        rotation: rotation,
      ),
    );
  }

  // ----------------------------------------------------------
  // UNDO
  // ----------------------------------------------------------

  void _undo() {
    if (_history.isEmpty) {
      _message('Nothing to undo.');
      return;
    }

    final previous = _history.removeLast();

    setState(() {
      brightness = previous.brightness;
      contrast = previous.contrast;
      saturation = previous.saturation;
      filter = previous.filter;
      rotation = previous.rotation;
    });
  }

  // ----------------------------------------------------------
  // RESET
  // ----------------------------------------------------------

  void _reset() {
    _saveHistory();

    setState(() {
      brightness = 0;
      contrast = 1;
      saturation = 1;
      filter = 0;
      rotation = 0;
    });
  }

  // ----------------------------------------------------------
  // ROTATE
  // ----------------------------------------------------------

  void _rotate() {
    _saveHistory();

    setState(() {
      rotation = (rotation + 1) % 4;
    });
  }

  // ----------------------------------------------------------
  // FILTER
  // ----------------------------------------------------------

  void _setFilter(int value) {
    if (filter == value) return;

    _saveHistory();

    setState(() {
      filter = value;
    });
  }

  // ----------------------------------------------------------
  // AI ENHANCE
  // ----------------------------------------------------------

  void _aiEnhance() {
    _saveHistory();

    setState(() {
      brightness = 0.04;
      contrast = 1.12;
      saturation = 1.08;
      filter = 0;
    });

    _message('AI Enhance applied.');
  }

  // ----------------------------------------------------------
  // COLOR MATRIX
  // ----------------------------------------------------------

  List<double> _matrix() {
    final b = brightness * 255;
    final c = contrast;
    final s = saturation;

    const red = 0.2126;
    const green = 0.7152;
    const blue = 0.0722;

    final inv = 1 - s;

    final r = inv * red;
    final g = inv * green;
    final bl = inv * blue;

    return [
      (r + s) * c,
      g * c,
      bl * c,
      0,
      b,

      r * c,
      (g + s) * c,
      bl * c,
      0,
      b,

      r * c,
      g * c,
      (bl + s) * c,
      0,
      b,

      0,
      0,
      0,
      1,
      0,
    ];
  }

  // ----------------------------------------------------------
  // FILTER MATRIX
  // ----------------------------------------------------------

  List<double> _filterMatrix() {
    // Original
    if (filter == 0) {
      return _matrix();
    }

    // Warm
    if (filter == 1) {
      return [
        1.12,
        0,
        0,
        0,
        8,

        0,
        1.02,
        0,
        0,
        3,

        0,
        0,
        0.88,
        0,
        -3,

        0,
        0,
        0,
        1,
        0,
      ];
    }

    // Cool
    if (filter == 2) {
      return [
        0.90,
        0,
        0,
        0,
        -2,

        0,
        1.02,
        0,
        0,
        0,

        0,
        0,
        1.12,
        0,
        8,

        0,
        0,
        0,
        1,
        0,
      ];
    }

    // Black & White
    if (filter == 3) {
      return [
        0.2126,
        0.7152,
        0.0722,
        0,
        0,

        0.2126,
        0.7152,
        0.0722,
        0,
        0,

        0.2126,
        0.7152,
        0.0722,
        0,
        0,

        0,
        0,
        0,
        1,
        0,
      ];
    }

    // Vintage
    if (filter == 4) {
      return [
        0.85,
        0.15,
        0.05,
        0,
        8,

        0.08,
        0.78,
        0.08,
        0,
        5,

        0.03,
        0.12,
        0.65,
        0,
        -2,

        0,
        0,
        0,
        1,
        0,
      ];
    }

    // High contrast
    if (filter == 5) {
      return [
        1.25,
        0,
        0,
        0,
        -25,

        0,
        1.25,
        0,
        0,
        -25,

        0,
        0,
        1.25,
        0,
        -25,

        0,
        0,
        0,
        1,
        0,
      ];
    }

    return _matrix();
  }

  // ----------------------------------------------------------
  // CAPTURE PREVIEW
  // ----------------------------------------------------------

  Future<Uint8List?> _captureImage() async {
    try {
      final renderObject =
          _previewKey.currentContext?.findRenderObject();

      if (renderObject is! RenderRepaintBoundary) {
        return null;
      }

      final ui.Image image = await renderObject.toImage(
        pixelRatio: 2.0,
      );

      final ByteData? byteData =
          await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        return null;
      }

      return byteData.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  // ----------------------------------------------------------
  // SAVE
  // ----------------------------------------------------------

  Future<void> _saveImage() async {
    final bytes = await _captureImage();

    if (bytes == null) {
      _message('Could not create image.');
      return;
    }

    try {
      final access = await Gal.requestAccess();

      if (!access) {
        _message('Gallery permission denied.');
        return;
      }

      await Gal.putImageBytes(
        bytes,
        album: 'AI Photo Editor',
        name:
            'ai_photo_${DateTime.now().millisecondsSinceEpoch}',
      );

      _message('Saved to Gallery.');
    } catch (_) {
      _message('Could not save image.');
    }
  }

  // ----------------------------------------------------------
  // SHARE
  // ----------------------------------------------------------

  Future<void> _shareImage() async {
    final bytes = await _captureImage();

    if (bytes == null) {
      _message('Could not create image.');
      return;
    }

    try {
      final directory = Directory.systemTemp;

      final fileName =
          'ai_photo_${DateTime.now().millisecondsSinceEpoch}.png';

      final path = '${directory.path}/$fileName';

      final file = File(path);

      await file.writeAsBytes(bytes);

      // Compatible with share_plus 7.x
      await Share.shareXFiles(
        [
          XFile(path),
        ],
        text: 'Edited with AI Photo Editor',
      );
    } catch (_) {
      _message('Could not share image.');
    }
  }

  // ----------------------------------------------------------
  // MESSAGE
  // ----------------------------------------------------------

  void _message(String text) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ----------------------------------------------------------
  // PREVIEW
  // ----------------------------------------------------------

  Widget _preview() {
    return RepaintBoundary(
      key: _previewKey,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        alignment: Alignment.center,
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(
            _filterMatrix(),
          ),
          child: RotatedBox(
            quarterTurns: rotation,
            child: Image.file(
              widget.file,
              fit: BoxFit.contain,
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 70,
                    color: Colors.white38,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // SLIDER
  // ----------------------------------------------------------

  Widget _slider({
    required String title,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              value.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.45),
              ),
            ),
          ],
        ),

        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: (newValue) {
            setState(() {
              onChanged(newValue);
            });
          },
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // FILTER LIST
  // ----------------------------------------------------------

  Widget _filters() {
    final items = [
      ('Original', 0),
      ('Warm', 1),
      ('Cool', 2),
      ('B&W', 3),
      ('Vintage', 4),
      ('Contrast', 5),
    ];

    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 9);
        },
        itemBuilder: (context, index) {
          final item = items[index];

          final selected = filter == item.$2;

          return GestureDetector(
            onTap: () {
              _setFilter(item.$2);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 82,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF8B5CF6)
                    : const Color(0xFF202027),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected
                      ? const Color(0xFFA78BFA)
                      : Colors.white.withOpacity(0.05),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                item.$1,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected
                      ? FontWeight.w800
                      : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ----------------------------------------------------------
  // TOOL BUTTON
  // ----------------------------------------------------------

  Widget _toolButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 24,
              ),

              const SizedBox(height: 6),

              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Editor',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _undo,
            tooltip: 'Undo',
            icon: const Icon(
              Icons.undo_rounded,
            ),
          ),
          IconButton(
            onPressed: _reset,
            tooltip: 'Reset',
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // --------------------------------------------------
          // IMAGE
          // --------------------------------------------------

          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                0,
                12,
                10,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: _preview(),
              ),
            ),
          ),

          // --------------------------------------------------
          // CONTROLS
          // --------------------------------------------------

          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                18,
                15,
                18,
                12,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF121219),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // BRIGHTNESS
                    _slider(
                      title: 'Brightness',
                      value: brightness,
                      min: -0.5,
                      max: 0.5,
                      onChanged: (value) {
                        brightness = value;
                      },
                    ),

                    // CONTRAST
                    _slider(
                      title: 'Contrast',
                      value: contrast,
                      min: 0.5,
                      max: 1.8,
                      onChanged: (value) {
                        contrast = value;
                      },
                    ),

                    // SATURATION
                    _slider(
                      title: 'Saturation',
                      value: saturation,
                      min: 0,
                      max: 2,
                      onChanged: (value) {
                        saturation = value;
                      },
                    ),

                    const SizedBox(height: 4),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    _filters(),

                    const SizedBox(height: 12),

                    // TOOLS
                    Row(
                      children: [
                        _toolButton(
                          icon: Icons.rotate_right_rounded,
                          label: 'Rotate',
                          onTap: _rotate,
                        ),

                        _toolButton(
                          icon: Icons.auto_awesome_rounded,
                          label: 'AI Enhance',
                          onTap: _aiEnhance,
                        ),

                        _toolButton(
                          icon: Icons.layers_clear_rounded,
                          label: 'Remove BG',
                          onTap: () {
                            _message(
                              'Background removal coming soon.',
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // SHARE + SAVE
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _shareImage,
                            icon: const Icon(
                              Icons.share_rounded,
                            ),
                            label: const Text(
                              'Share',
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize:
                                  const Size.fromHeight(54),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _saveImage,
                            icon: const Icon(
                              Icons.download_rounded,
                            ),
                            label: const Text(
                              'Save',
                            ),
                            style: FilledButton.styleFrom(
                              minimumSize:
                                  const Size.fromHeight(54),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
