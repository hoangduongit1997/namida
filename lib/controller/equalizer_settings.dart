import 'package:namida/base/settings_file_writer.dart';
import 'package:namida/core/constants.dart';
import 'package:namida/core/extensions.dart';

class EqualizerSettings with SettingsFileWriter {
  static final EqualizerSettings inst = EqualizerSettings._internal();
  EqualizerSettings._internal();

  int? preset;
  bool equalizerEnabled = false;
  final equalizer = <double, double>{};
  bool loudnessEnhancerEnabled = false;
  double loudnessEnhancer = 0.0;

  void save({
    int? preset,
    bool resetPreset = false,
    bool? equalizerEnabled,
    MapEntry<double, double>? equalizerValue,
    bool? loudnessEnhancerEnabled,
    double? loudnessEnhancer,
  }) {
    if (preset != null || resetPreset) this.preset = preset;
    if (equalizerEnabled != null) this.equalizerEnabled = equalizerEnabled;
    if (equalizerValue != null) equalizer[equalizerValue.key] = equalizerValue.value;
    if (loudnessEnhancerEnabled != null) this.loudnessEnhancerEnabled = loudnessEnhancerEnabled;
    if (loudnessEnhancer != null) this.loudnessEnhancer = loudnessEnhancer;
    _writeToStorage();
  }

  Future<void> prepareSettingsFile() async {
    final json = await prepareSettingsFile_();
    if (json == null) return;
    try {
      preset = json["preset"];
      equalizerEnabled = json["equalizerEnabled"] ?? false;
      final eqMap = json['equalizer'];
      if (eqMap is Map) {
        equalizer.clear();
        final m = eqMap.cast<String, double>();
        equalizer.addAll(m.map((key, value) => MapEntry(double.parse(key), value)));
      }
      loudnessEnhancerEnabled = json["loudnessEnhancerEnabled"] ?? false;
      loudnessEnhancer = json["loudnessEnhancer"] ?? 0.0;
    } catch (e) {
      printy(e, isError: true);
    }
  }

  @override
  Object get jsonToWrite => <String, dynamic>{
        "preset": preset,
        "equalizerEnabled": equalizerEnabled,
        "equalizer": equalizer.map((key, value) => MapEntry(key.toString(), value)),
        "loudnessEnhancerEnabled": loudnessEnhancerEnabled,
        "loudnessEnhancer": loudnessEnhancer,
      };

  Future<void> _writeToStorage() async => await writeToStorage();

  @override
  String get filePath => AppPaths.SETTINGS_EQUALIZER;
}