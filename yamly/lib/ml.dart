import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class MlKit {
  final ImageLabeler imageLabeler = FirebaseVision.instance.cloudImageLabeler(
    CloudImageLabelerOptions(confidenceThreshold: 0.5)
  );

  Future<List<ImageLabel>> getImageLabels(FirebaseVisionImage visionImage) async {
    return await imageLabeler.processImage(visionImage);
  }
}

final MlKit mlKit = MlKit();