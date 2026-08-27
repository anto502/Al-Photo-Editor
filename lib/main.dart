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
// HOME
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
      final XFile? selected = await _picker.pickImage(
        source: source,
        imageQuality: 95,
      );

      if (selected == null || !mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditorScreen(
            file: File(selected.path),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage('Could not open image.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showPhotoPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17171E),
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
              20,
              20,
              30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Choose a Photo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  leading: const CircleAvatar(
                    child: Icon(
                      Icons.photo_library_rounded,
                    ),
                  ),
                  title: const Text('Gallery'),
                  subtitle: const Text(
                    'Choose an existing photo',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 6),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  leading: const CircleAvatar(
                    child: Icon(
                      Icons.camera_alt_rounded,
                    ),
                  ),
                  title: const Text('Camera'),
                  subtitle: const Text(
                    'Take a new photo',
                  ),
                  onTap: () {
                    Navigator.pop(context);
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
            24,
            20,
            30,
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
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
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
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Photo Editor',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Edit • Enhance • Create',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.settings_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 42),

              // HERO
              const Text(
                'Create something\namazing.',
                style: TextStyle(
                  fontSize: 40,
                  height: 1.04,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Edit, enhance and transform your photos '
                'with powerful tools.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),

              const SizedBox(height: 36),

              // FEATURE CARDS
              Row(
                children: [
                  Expanded(
                    child: _FeatureCard(
                      icon: Icons.auto_awesome_rounded,
                      title: 'AI Enhance',
                      subtitle: 'Improve photos',
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

              // PICK PHOTO BUTTON
              SizedBox(
                width: double.infinity,
                height: 62,
                child: FilledButton.icon(
                  onPressed: _showPhotoPicker,
                  icon: const Icon(
                    Icons.add_photo_alternate_rounded,
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

              const SizedBox(height: 18),

              Center(
                child: Text(
                  'Your photos stay on your device.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 12,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF15151B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 27,
            color: const Color(0xFFA78BFA),
          ),
          const SizedBox(height: 15),
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
              color: Colors.white.withValues(alpha: 0.45),
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
  final File file;

  const EditorScreen({
    super.key,
    required this.file,
  });

  @override
  State<EditorScreen> createState() =>
      _EditorScreenState();
}

class _EditorState {
  final double brightness;
  final double contrast;
  final double saturation;
  final int filter;
  final int rotation;

  const _EditorState({
    required this.brightness,
    required this.contrast,
    required this.saturation,
    required this.filter,
    required this.rotation,
  });
}

class _EditorScreenState extends State<EditorScreen> {
  final GlobalKey _previewKey = GlobalKey();

  double brightness = 0;
  double contrast = 1;
  double saturation = 1;

  int filter = 0;
  int rotation = 0;

  final List<_EditorState> _history = [];

  // ==========================================================
  // HISTORY
  // ==========================================================

  void _saveState() {
    _history.add(
      _EditorState(
        brightness: brightness,
        contrast: contrast,
        saturation: saturation,
        filter: filter,
        rotation: rotation,
      ),
    );
  }

  void _undo() {
    if (_history.isEmpty) return;

    final previous = _history.removeLast();

    setState(() {
      brightness = previous.brightness;
      contrast = previous.contrast;
      saturation = previous.saturation;
      filter = previous.filter;
      rotation = previous.rotation;
    });
  }

  void _reset() {
    _saveState();

    setState(() {
      brightness = 0;
      contrast = 1;
      saturation = 1;
      filter = 0;
      rotation = 0;
    });
  }

  // ==========================================================
  // COLOR FILTER
  // ==========================================================

  List<double> _colorMatrix() {
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

    final List<double> matrix = [
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

    // WARM
    if (filter == 1) {
      return [
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
      ];
    }

    // COOL
    if (filter == 2) {
      return [
        0.92,
        0,
        0,
        0,
        0,
        0,
        1.0,
        0,
        0,
        0,
        0,
        0,
        1.12,
        0,
        5,
        0,
        0,
        0,
        1,
        0,
      ];
    }

    // BLACK & WHITE
    if (filter == 3) {
      return [
        0.33,
        0.59,
        0.11,
        0,
        0,
        0.33,
        0.59,
        0.11,
        0,
        0,
        0.33,
        0.59,
        0.11,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ];
    }

    return matrix;
  }

  ColorFilter _filterEffect() {
    return ColorFilter.matrix(
      _colorMatrix(),
    );
  }

  // ==========================================================
  // CAPTURE
  // ==========================================================

  Future<Uint8List?> _captureEditedImage() async {
    try {
      final RenderObject? object =
          _previewKey.currentContext?.findRenderObject();

      if (object is! RenderRepaintBoundary) {
        return null;
      }

      final ui.Image image =
          await object.toImage(
        pixelRatio: 2.5,
      );

      final ByteData? data =
          await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      image.dispose();

      return data?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  // ==========================================================
  // SAVE
  // ==========================================================

  Future<void> _saveImage() async {
    final Uint8List? bytes =
        await _captureEditedImage();

    if (bytes == null) {
      _message('Could not export image.');
      return;
    }

    try {
      final bool hasAccess =
          await Gal.requestAccess();

      if (!hasAccess) {
        _message(
          'Gallery permission was denied.',
        );
        return;
      }

      await Gal.putImageBytes(
        bytes,
        album: 'AI Photo Editor',
        name:
            'ai_photo_${DateTime.now().millisecondsSinceEpoch}',
      );

      _message(
        'Photo saved to gallery!',
      );
    } catch (e) {
      _message(
        'Save failed.',
      );
    }
  }

  // ==========================================================
  // SHARE
  // ==========================================================

  Future<void> _shareImage() async {
    final Uint8List? bytes =
        await _captureEditedImage();

    if (bytes == null) {
      _message('Could not export image.');
      return;
    }

    try {
      final String fileName =
          'ai_photo_${DateTime.now().millisecondsSinceEpoch}.png';

      final Directory directory =
          Directory.systemTemp;

      final String path =
          '${directory.path}/$fileName';

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
    } catch (e) {
      _message('Share failed.');
    }
  }

  void _message(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================================
  // TOOLS
  // ==========================================================

  void _rotate() {
    _saveState();

    setState(() {
      rotation = (rotation + 1) % 4;
    });
  }

  void _selectFilter(int value) {
    if (filter == value) return;

    _saveState();

    setState(() {
      filter = value;
    });
  }

  // ==========================================================
  // PREVIEW
  // ==========================================================

  Widget _buildPreview() {
    return RepaintBoundary(
      key: _previewKey,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Center(
          child: ColorFiltered(
            colorFilter: _filterEffect(),
            child: RotatedBox(
              quarterTurns: rotation,
              child: Image.file(
                widget.file,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // SLIDER
  // ==========================================================

  Widget _slider({
    required String title,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
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
                color: Colors.white
                    .withValues(alpha: 0.5),
                fontSize: 12,
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

  // ==========================================================
  // FILTERS
  // ==========================================================

  Widget _filters() {
    final List<Map<String, dynamic>> filters = [
      {
        'name': 'Original',
        'value': 0,
      },
      {
        'name': 'Warm',
        'value': 1,
      },
      {
        'name': 'Cool',
        'value': 2,
      },
      {
        'name': 'B&W',
        'value': 3,
      },
    ];

    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final String name =
              filters[index]['name'] as String;

          final int value =
              filters[index]['value'] as int;

          final bool selected =
              filter == value;

          return GestureDetector(
            onTap: () => _selectFilter(value),
            child: Container(
              width: 82,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF8B5CF6)
                    : const Color(0xFF1A1A21),
                borderRadius:
                    BorderRadius.circular(16),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF8B5CF6)
                      : Colors.white
                          .withValues(alpha: 0.06),
                ),
              ),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                    fontWeight: selected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================================
  // TOOL BUTTON
  // ==========================================================

  Widget _toolButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius:
          BorderRadius.circular(15),
      onTap: onTap,
      child: SizedBox(
        width: 82,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 23,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // BUILD EDITOR
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
            tooltip: 'Undo',
            onPressed: _undo,
            icon: const Icon(
              Icons.undo_rounded,
            ),
          ),
          IconButton(
            tooltip: 'Reset',
            onPressed: _reset,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // IMAGE
          Expanded(
            flex: 5,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(22),
                child: _buildPreview(),
              ),
            ),
          ),

          // CONTROLS
          Expanded(
            flex: 5,
            child: Container(
              padding:
                  const EdgeInsets.fromLTRB(
                18,
                12,
                18,
                12,
              ),
              decoration:
                  const BoxDecoration(
                color: Color(0xFF121218),
                borderRadius:
                    BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _slider(
                      title: 'Brightness',
                      value: brightness,
                      min: -0.5,
                      max: 0.5,
                      onChanged: (value) {
                        brightness = value;
                      },
                    ),

                    _slider(
                      title: 'Contrast',
                      value: contrast,
                      min: 0.5,
                      max: 1.8,
                      onChanged: (value) {
                        contrast = value;
                      },
                    ),

                    _slider(
                      title: 'Saturation',
                      value: saturation,
                      min: 0,
                      max: 2,
                      onChanged: (value) {
                        saturation = value;
                      },
                    ),

                    const SizedBox(height: 6),

                    const Align(
                      alignment:
                          Alignment.centerLeft,
                      child: Text(
                        'Filters',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    _filters(),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceAround,
                      children: [
                        _toolButton(
                          icon: Icons
                              .rotate_right_rounded,
                          label: 'Rotate',
                          onTap: _rotate,
                        ),
                        _toolButton(
                          icon: Icons
                              .auto_awesome_rounded,
                          label: 'AI Enhance',
                          onTap: () {
                            _message(
                              'AI Enhance coming soon.',
                            );
                          },
                        ),
                        _toolButton(
                          icon: Icons
                              .layers_clear_rounded,
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

                    Row(
                      children: [
                        Expanded(
                          child:
                              OutlinedButton.icon(
                            onPressed:
                                _shareImage,
                            icon: const Icon(
                              Icons.share_rounded,
                            ),
                            label:
                                const Text('Share'),
                            style:
                                OutlinedButton
                                    .styleFrom(
                              minimumSize:
                                  const Size
                                      .fromHeight(
                                54,
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  16,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child:
                              FilledButton.icon(
                            onPressed:
                                _saveImage,
                            icon: const Icon(
                              Icons
                                  .download_rounded,
                            ),
                            label:
                                const Text('Save'),
                            style:
                                FilledButton
                                    .styleFrom(
                              minimumSize:
                                  const Size
                                      .fromHeight(
                                54,
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
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
