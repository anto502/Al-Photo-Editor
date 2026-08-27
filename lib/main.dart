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
        scaffoldBackgroundColor: const Color(0xFF0B0B0F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5CF6),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? file = await _picker.pickImage(
      source: source,
      imageQuality: 95,
    );

    if (file == null || !mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditorScreen(file: File(file.path)),
      ),
    );
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17171D),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose Photo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.photo_library_rounded),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_rounded),
                  title: const Text('Camera'),
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF8B5CF6),
                          Color(0xFFEC4899),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'AI Photo Editor',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),

              const SizedBox(height: 45),

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
                'Edit your photos with powerful tools and AI.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.60),
                ),
              ),

              const Spacer(),

              // AI feature cards
              Row(
                children: [
                  Expanded(
                    child: _FeatureCard(
                      icon: Icons.auto_awesome,
                      title: 'AI Enhance',
                      subtitle: 'Improve photo',
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

              SizedBox(
                width: double.infinity,
                height: 62,
                child: FilledButton.icon(
                  onPressed: _showPicker,
                  icon: const Icon(Icons.add_photo_alternate_rounded),
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

              const SizedBox(height: 16),

              Center(
                child: Text(
                  'Your photos stay on your device.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
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
          color: Colors.white.withOpacity(0.07),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              color: Colors.white.withOpacity(0.45),
            ),
          ),
        ],
      ),
    );
  }
}

class EditorScreen extends StatefulWidget {
  final File file;

  const EditorScreen({
    super.key,
    required this.file,
  });

  @override
  State<EditorScreen> createState() => _EditorScreenState();
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

    final state = _history.removeLast();

    setState(() {
      brightness = state.brightness;
      contrast = state.contrast;
      saturation = state.saturation;
      filter = state.filter;
      rotation = state.rotation;
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

  List<double> _colorMatrix() {
    final b = brightness * 255;
    final c = contrast;
    final s = saturation;

    final sr = 0.2126;
    final sg = 0.7152;
    final sb = 0.0722;

    final inv = 1 - s;
    final r = inv * sr;
    final g = inv * sg;
    final bl = inv * sb;

    final matrix = <double>[
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

    if (filter == 1) {
      return <double>[
        1.15, 0, 0, 0, 8,
        0, 1.02, 0, 0, 4,
        0, 0, 0.92, 0, -2,
        0, 0, 0, 1, 0,
      ];
    }

    if (filter == 2) {
      return <double>[
        0.55, 0.25, 0.15, 0, 0,
        0.55, 0.25, 0.15, 0, 0,
        0.55, 0.25, 0.15, 0, 0,
        0, 0, 0, 1, 0,
      ];
    }

    if (filter == 3) {
      return <double>[
        0.33, 0.59, 0.11, 0, 0,
        0.33, 0.59, 0.11, 0, 0,
        0.33, 0.59, 0.11, 0, 0,
        0, 0, 0, 1, 0,
      ];
    }

    return matrix;
  }

  ColorFilter _filterEffect() {
    return ColorFilter.matrix(_colorMatrix());
  }

  Future<Uint8List?> _captureEditedImage() async {
    try {
      final boundary =
          _previewKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) return null;

      final ui.Image image = await boundary.toImage(
        pixelRatio: 2.5,
      );

      final ByteData? data = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      return data?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveImage() async {
    final bytes = await _captureEditedImage();

    if (bytes == null) {
      _message('Could not export image.');
      return;
    }

    try {
      final hasAccess = await Gal.requestAccess();

      if (!hasAccess) {
        _message('Gallery permission was denied.');
        return;
      }

      await Gal.putImageBytes(
        bytes,
        album: 'AI Photo Editor',
        name: 'ai_photo_${DateTime.now().millisecondsSinceEpoch}',
      );

      _message('Photo saved to gallery!');
    } catch (e) {
      _message('Save failed: $e');
    }
  }

  Future<void> _shareImage() async {
    final bytes = await _captureEditedImage();

    if (bytes == null) {
      _message('Could not export image.');
      return;
    }

    try {
      final fileName =
          'ai_photo_${DateTime.now().millisecondsSinceEpoch}.png';

      final tempDirectory = Directory.systemTemp;
      final path = '${tempDirectory.path}/$fileName';

      final file = File(path);
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
      _message('Share failed: $e');
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

  void _rotate() {
    _saveState();

    setState(() {
      rotation = (rotation + 1) % 4;
    });
  }

  void _selectFilter(int value) {
    _saveState();

    setState(() {
      filter = value;
    });
  }

  Widget _buildPreview() {
    return RepaintBoundary(
      key: _previewKey,
      child: Container(
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

  Widget _toolButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Icon(icon, size: 23),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slider({
    required String title,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                color: Colors.white.withOpacity(0.5),
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
            if (_history.isEmpty ||
                title == 'Brightness' ||
                title == 'Contrast' ||
                title == 'Saturation') {
              // Continuous slider editing.
            }

            setState(() {
              onChanged(newValue);
            });
          },
        ),
      ],
    );
  }

  Widget _filters() {
    final filters = [
      ('Original', 0),
      ('Warm', 1),
      ('Cool', 2),
      ('B&W', 3),
    ];

    return SizedBox(
      height: 85,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = filters[index];
          final selected = filter == item.$2;

          return GestureDetector(
            onTap: () => _selectFilter(item.$2),
            child: Container(
              width: 82,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF8B5CF6)
                    : const Color(0xFF1A1A21),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF8B5CF6)
                      : Colors.white.withOpacity(0.06),
                ),
              ),
              child: Center(
                child: Text(
                  item.$1,
                  style: TextStyle(
                    fontWeight:
                        selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Undo',
            onPressed: _undo,
            icon: const Icon(Icons.undo_rounded),
          ),
          IconButton(
            tooltip: 'Reset',
            onPressed: _reset,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: _buildPreview(),
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
              decoration: const BoxDecoration(
                color: Color(0xFF121218),
                borderRadius: BorderRadius.vertical(
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
                      onChanged: (v) => brightness = v,
                    ),
                    _slider(
                      title: 'Contrast',
                      value: contrast,
                      min: 0.5,
                      max: 1.8,
                      onChanged: (v) => contrast = v,
                    ),
                    _slider(
                      title: 'Saturation',
                      value: saturation,
                      min: 0,
                      max: 2,
                      onChanged: (v) => saturation = v,
                    ),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Filters',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    _filters(),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _toolButton(
                          icon: Icons.rotate_right_rounded,
                          label: 'Rotate',
                          onTap: _rotate,
                        ),
                        _toolButton(
                          icon: Icons.auto_awesome_rounded,
                          label: 'AI Enhance',
                          onTap: () {
                            _message(
                              'AI Enhance will be connected next.',
                            );
                          },
                        ),
                        _toolButton(
                          icon: Icons.layers_clear_rounded,
                          label: 'Remove BG',
                          onTap: () {
                            _message(
                              'Background removal will be connected next.',
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _shareImage,
                            icon: const Icon(Icons.share_rounded),
                            label: const Text('Share'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _saveImage,
                            icon: const Icon(Icons.download_rounded),
                            label: const Text('Save'),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
