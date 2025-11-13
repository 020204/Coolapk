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



class EditTextDialog extends StatefulWidget {
  const EditTextDialog({
    super.key,
    required this.title,
    required this.defaultText,
    required this.setData,
  });

  final String title;
  final String defaultText;
  final Function(String value) setData;

  @override
  State<EditTextDialog> createState() => _EditTextDialogState();
}

class _EditTextDialogState extends State<EditTextDialog>
    with SingleTickerProviderStateMixin {
  late TextEditingController controller;
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.defaultText);

    // 初始化滑入动画
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _offsetAnimation = Tween(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // 启动滑入动画
    _animationController.forward();

    // 延迟聚焦，避免键盘与面板同时弹出造成抖动
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void confirm() {
    widget.setData(controller.text.trim());
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return SlideTransition(
      position: _offsetAnimation,
      child: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: bottom),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.title,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  focusNode: _focusNode,
                  autofocus: false,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => confirm(),
                  decoration: InputDecoration(
                    hintText: '请输入内容',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('取消'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: confirm,
                      child: const Text('确认'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
