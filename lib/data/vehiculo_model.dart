class VehiculoModel {
  late int? id;
  late String? placa;
  late String? color;
  late String? marca;
  late String? modelo;
  late int? anio;
  late int? kilometraje;
  late int? estadoVehiculoId;
  late int? userId;
  late DateTime? createdAt;
  late DateTime? updatedAt;

  VehiculoModel({
     this.id,
     this.placa,
     this.color,
     this.marca,
     this.modelo,
     this.anio,
     this.kilometraje,
     this.estadoVehiculoId,
    this.userId,
     this.createdAt,
     this.updatedAt,
  });

  factory VehiculoModel.fromJson(Map<String, dynamic> json) {
    return VehiculoModel(
      id: json['id'],
      placa: json['placa'],
      color: json['color'],
      marca: json['marca'],
      modelo: json['modelo'],
      anio: json['anio'],
      kilometraje: json['kilometraje'],
      estadoVehiculoId: json['estado_vehiculo_id'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placa': placa,
      'color': color,
      'marca': marca,
      'modelo': modelo,
      'anio': anio,
      'kilometraje': kilometraje,
      'estado_vehiculo_id': estadoVehiculoId,
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
