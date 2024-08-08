import 'package:app_registro_movil/data/vehiculo_model.dart';

class VehiculoDataModel {
  final List<VehiculoModel> data;
 

  VehiculoDataModel({
     required this.data,
  });

  factory VehiculoDataModel.fromJson(Map<String, dynamic> json) {
    return VehiculoDataModel(
      data: List<VehiculoModel>.from(
        json["data"].map((x) => VehiculoModel.fromJson(x)),
      )
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}
