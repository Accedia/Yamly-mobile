import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class MlKit {
  final ImageLabeler imageLabeler = FirebaseVision.instance.imageLabeler(
    ImageLabelerOptions(confidenceThreshold: 0.75)
  );

  Future<List<ImageLabel>> getImageLabels(FirebaseVisionImage visionImage) async {
    return await imageLabeler.processImage(visionImage);
  }
}

final MlKit mlKit = MlKit();