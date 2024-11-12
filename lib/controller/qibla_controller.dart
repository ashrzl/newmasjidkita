import 'package:new_mk_v3/model/qibla_model.dart';

class QiblahController {
  final QiblahModel qiblahModel;

  QiblahController(this.qiblahModel);

  void checkLocationStatus() {
    qiblahModel.checkLocationStatus();
  }

  Future<bool?> getDeviceSupport() {
    return qiblahModel.getDeviceSupport();
  }

  void dispose() {
    qiblahModel.dispose();
  }
}
