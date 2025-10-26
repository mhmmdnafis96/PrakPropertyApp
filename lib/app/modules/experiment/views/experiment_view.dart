import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/experiment_controller.dart';
import 'package:flutter/services.dart';


class ExperimentView extends GetView<ExperimentController> {
  // pakai RxBool lokal untuk status running
  final RxBool _running = false.obs;

  ExperimentView({super.key}); // hapus const agar bisa punya field non-const

  Future<void> _run() async {
    if (_running.value) return;
    _running.value = true;
    try {
      await controller.runExperiment();
    } finally {
      _running.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eksperimen HTTP vs Dio')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Obx(() => ElevatedButton.icon(
                      onPressed: _running.value ? null : _run,
                      icon: _running.value
                          ? const SizedBox(
                              width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.play_arrow),
                      label: Text(_running.value ? 'Sedang berjalan...' : 'Jalankan Eksperimen'),
                    )),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => controller.log.value = '',
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Log'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    final data = controller.log.value;
                    if (data.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: data));
                      Get.snackbar('Disalin', 'Log telah disalin ke clipboard',
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(
                () => Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        controller.log.value,
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
