import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';
import '../utils/utils.dart';

class SliderDialog extends StatefulWidget {
  const SliderDialog(
      {super.key, required this.fontScale, required this.setData});

  final double fontScale;
  final Function(double newValue) setData;

  @override
  State<SliderDialog> createState() => _SliderDialogState();
}

class _SliderDialogState extends State<SliderDialog> {
  late double _fontScale;

  @override
  void initState() {
    super.initState();
    _fontScale = widget.fontScale;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('字体比例')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slider(
            min: 0.5,
            max: 2.0,
            value: _fontScale,
            secondaryTrackValue: 1,
            onChanged: (value) => setState(() => _fontScale = value),
          ),
          Text(
            '字体大小: ${_fontScale.toStringAsFixed(2)}x',
            style: TextStyle(fontSize: 15 * _fontScale),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.setData(1.00);
            Get.back();
          },
          child: const Text('重置'),
        ),
        TextButton(
          onPressed: () {
            widget.setData(_fontScale);
            Get.back();
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}

class EditTextBottomSheet extends StatefulWidget {
  const EditTextBottomSheet({
    super.key,
    required this.title,
    required this.defaultText,
    required this.setData,
  });

  final String title;
  final String defaultText;
  final Function(String value) setData;

  @override
  State<EditTextBottomSheet> createState() => _EditTextBottomSheetState();
}

class _EditTextBottomSheetState extends State<EditTextBottomSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.defaultText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() {
    widget.setData(_controller.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            autofocus: true,
            controller: _controller,
            onSubmitted: (value) => _onConfirm(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _onConfirm,
                  child: const Text('确定'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class MAboutDialog extends StatelessWidget {
  const MAboutDialog({super.key, required this.version});

  final String version;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.all_inclusive),
          const SizedBox(width: 12.0),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HtmlWidget(
                  '''
                  <font size="6">${Constants.APP_NAME}</font><br>
                  $version<br><br>
                  View source code at <b><a href="${Constants.URL_SOURCE_CODE}">GitHub</a></b>
                  ''',
                  onTapUrl: (url) {
                    Utils.launchURL(url);
                    return true;
                  },
                ),
              ],
            ),
          )
        ],
      ),
      actions: [
        TextButton(
          child: const Text('查看许可证'),
          onPressed: () {
            showLicensePage(
              context: context,
              applicationName: Constants.APP_NAME,
              applicationVersion: '1.0.0',
              applicationIcon: const Icon(Icons.all_inclusive),
            );
          },
        ),
        TextButton(
          child: const Text('关闭'),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }
}

class ClearDialog extends StatelessWidget {
  const ClearDialog(
      {super.key, required this.cacheSize, required this.onClearCache});

  final String cacheSize;
  final Function() onClearCache;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('清除缓存')),
      content: Text('当前缓存大小: $cacheSize'),
      actions: [
        TextButton(
          child: const Text('取消'),
          onPressed: () => Get.back(),
        ),
        TextButton(
          child: const Text('确定'),
          onPressed: () {
            onClearCache();
            Get.back();
          },
        ),
      ],
    );
  }
}
