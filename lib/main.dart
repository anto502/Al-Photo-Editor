import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const AIPhotoEditorApp());
}

class AIPhotoEditorApp extends StatelessWidget {
  const AIPhotoEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Photo Editor',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
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
// HOME
// ============================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 95,
      );

      if (image == null) return;

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditorScreen(
            imageFile: File(image.path),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      showMessage('Could not open image.');
    }
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void openPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17171F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Choose a Photo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.photo_library),
                  ),
                  title: const Text(
                    'Gallery',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Choose an existing photo',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.camera_alt),
                  ),
                  title: const Text(
                    'Camera',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Take a new photo',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.camera);
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF8B5CF6),
                          Color(0xFFEC4899),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 28,
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
                      showMessage('Settings coming soon.');
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
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Edit your photos with powerful tools.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.55),
                ),
              ),

              const Spacer(),

              // FEATURES
              Row(
                children: [
                  Expanded(
                    child: FeatureCard(
                      icon: Icons.auto_awesome,
                      title: 'AI Enhance',
                      subtitle: 'Improve photo',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FeatureCard(
                      icon: Icons.layers_clear,
                      title: 'Remove BG',
                      subtitle: 'Coming soon',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // PICK BUTTON
              SizedBox(
                width: double.infinity,
                height: 62,
                child: FilledButton.icon(
                  onPressed: openPicker,
                  icon: const Icon(
                    Icons.add_photo_alternate,
                  ),
                  label: const Text(
                    'Choose a Photo',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

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
// FEATURE CARD
// ============================================================

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF15151C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFFA78BFA),
            size: 28,
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
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
    );
  }
}

// ============================================================
// EDITOR
// ============================================================

class EditorScreen extends StatefulWidget {
  final File imageFile;

  const EditorScreen({
    super.key,
    required this.imageFile,
  });

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final GlobalKey previewKey = GlobalKey();

  double brightness = 0;
  double contrast = 1;
  double saturation = 1;

  int filter = 0;
  int rotation = 0;

  // ==========================================================
  // COLOR
  // ==========================================================

  ColorFilter getColorFilter() {
    // ORIGINAL
    if (filter == 0) {
      return ColorFilter.matrix(
        createColorMatrix(),
      );
    }

    // WARM
    if (filter == 1) {
      return const ColorFilter.matrix(
        [
          1.15,
          0,
          0,
          0,
          8,
          0,
          1.02,
          0,
          0,
          4,
          0,
          0,
          0.92,
          0,
          -2,
          0,
          0,
          0,
          1,
          0,
        ],
      );
    }

    // COOL
    if (filter == 2) {
      return const ColorFilter.matrix(
        [
          0.92,
          0,
          0,
          0,
          0,
          0,
          1.02,
          0,
          0,
          0,
          0,
          0,
          1.15,
          0,
          5,
          0,
          0,
          0,
          1,
          0,
        ],
      );
    }

    // BLACK & WHITE
    return const ColorFilter.matrix(
      [
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
      ],
    );
  }

  List<double> createColorMatrix() {
    final double b = brightness * 255;
    final double c = contrast;
    final double s = saturation;

    const double sr = 0.2126;
    const double sg = 0.7152;
    const double sb = 0.0722;

    final double inv = 1 - s;

    final double r = inv * sr;
    final double g = inv * sg;
    final double bl = inv * sb;

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

  // ==========================================================
  // PREVIEW
  // ==========================================================

  Widget buildPreview() {
    return RepaintBoundary(
      key: previewKey,
      child: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: ColorFiltered(
          colorFilter: getColorFilter(),
          child: RotatedBox(
            quarterTurns: rotation,
            child: Image.file(
              widget.imageFile,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.broken_image,
                  size: 60,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // ROTATE
  // ==========================================================

  void rotateImage() {
    setState(() {
      rotation = (rotation + 1) % 4;
    });
  }

  // ==========================================================
  // RESET
  // ==========================================================

  void resetEditor() {
    setState(() {
      brightness = 0;
      contrast = 1;
      saturation = 1;
      filter = 0;
      rotation = 0;
    });
  }

  // ==========================================================
  // CAPTURE
  // ==========================================================

  Future<Uint8List?> captureImage() async {
    try {
      final RenderObject? object =
          previewKey.currentContext?.findRenderObject();

      if (object is! RenderRepaintBoundary) {
        return null;
      }

      final ui.Image image = await object.toImage(
        pixelRatio: 2.0,
      );

      final ByteData? data = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      return data?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  // ==========================================================
  // SAVE
  // ==========================================================

  Future<void> saveImage() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final Uint8List? bytes = await captureImage();

      if (!mounted) return;

      Navigator.pop(context);

      if (bytes == null) {
        showMessage('Could not export image.');
        return;
      }

      final bool permission =
          await Gal.requestAccess();

      if (!permission) {
        showMessage('Gallery permission denied.');
        return;
      }

      final String name =
          'ai_photo_${DateTime.now().millisecondsSinceEpoch}';

      await Gal.putImageBytes(
        bytes,
        album: 'AI Photo Editor',
        name: name,
      );

      showMessage('Photo saved successfully!');
    } catch (_) {
      if (mounted) {
        Navigator.pop(context);
        showMessage('Could not save photo.');
      }
    }
  }

  // ==========================================================
  // SHARE
  // ==========================================================

  Future<void> shareImage() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final Uint8List? bytes = await captureImage();

      if (!mounted) return;

      Navigator.pop(context);

      if (bytes == null) {
        showMessage('Could not export image.');
        return;
      }

      final Directory directory =
          Directory.systemTemp;

      final String path =
          '${directory.path}/ai_photo_${DateTime.now().millisecondsSinceEpoch}.png';

      final File file = File(path);

      await file.writeAsBytes(bytes);

      await SharePlus.instance.share(
        ShareParams(
          text: 'Edited with AI Photo Editor',
          files: [
            XFile(path),
          ],
        ),
      );
    } catch (_) {
      if (mounted) {
        Navigator.pop(context);
        showMessage('Could not share photo.');
      }
    }
  }

  // ==========================================================
  // MESSAGE
  // ==========================================================

  void showMessage(String text) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================================
  // FILTER BUTTON
  // ==========================================================

  Widget filterButton(
    String name,
    int value,
  ) {
    final bool selected = filter == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          filter = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        width: 82,
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF8B5CF6)
              : const Color(0xFF1A1A22),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          name,
          style: TextStyle(
            fontWeight:
                selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // SLIDER
  // ==========================================================

  Widget editorSlider({
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
                fontWeight: FontWeight.w600,
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
          onChanged: onChanged,
        ),
      ],
    );
  }

  // ==========================================================
  // TOOL
  // ==========================================================

  Widget toolButton({
    required IconData icon,
    required String title,
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
                size: 25,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editor',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: resetEditor,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // IMAGE PREVIEW
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
                child: buildPreview(),
              ),
            ),
          ),

          // EDIT CONTROLS
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
                color: Color(0xFF121218),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    editorSlider(
                      title: 'Brightness',
                      value: brightness,
                      min: -0.5,
                      max: 0.5,
                      onChanged: (value) {
                        setState(() {
                          brightness = value;
                        });
                      },
                    ),

                    editorSlider(
                      title: 'Contrast',
                      value: contrast,
                      min: 0.5,
                      max: 1.8,
                      onChanged: (value) {
                        setState(() {
                          contrast = value;
                        });
                      },
                    ),

                    editorSlider(
                      title: 'Saturation',
                      value: saturation,
                      min: 0,
                      max: 2,
                      onChanged: (value) {
                        setState(() {
                          saturation = value;
                        });
                      },
                    ),

                    const SizedBox(height: 5),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      height: 82,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          filterButton(
                            'Original',
                            0,
                          ),
                          const SizedBox(width: 10),
                          filterButton(
                            'Warm',
                            1,
                          ),
                          const SizedBox(width: 10),
                          filterButton(
                            'Cool',
                            2,
                          ),
                          const SizedBox(width: 10),
                          filterButton(
                            'B&W',
                            3,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        toolButton(
                          icon: Icons.rotate_right,
                          title: 'Rotate',
                          onTap: rotateImage,
                        ),
                        toolButton(
                          icon: Icons.auto_awesome,
                          title: 'AI Enhance',
                          onTap: () {
                            showMessage(
                              'AI Enhance coming soon.',
                            );
                          },
                        ),
                        toolButton(
                          icon: Icons.layers_clear,
                          title: 'Remove BG',
                          onTap: () {
                            showMessage(
                              'Remove Background coming soon.',
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: shareImage,
                            icon: const Icon(
                              Icons.share,
                            ),
                            label: const Text(
                              'Share',
                            ),
                            style:
                                OutlinedButton.styleFrom(
                              minimumSize:
                                  const Size.fromHeight(
                                54,
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: saveImage,
                            icon: const Icon(
                              Icons.download,
                            ),
                            label: const Text(
                              'Save',
                            ),
                            style:
                                FilledButton.styleFrom(
                              minimumSize:
                                  const Size.fromHeight(
                                54,
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
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
