class VehiculoDetalleModel {
  late int? id;
  // ignore: non_constant_identifier_names
  late int? vehiculo_id;
  // ignore: non_constant_identifier_names
  late int? detalle_id;
  late bool? estado;
  late double? valor;
  late DateTime? createdAt;
  late DateTime? updatedAt;

  VehiculoDetalleModel({
     this.id,
     this.vehiculo_id,
     this.detalle_id,
     this.estado,
     this.valor,
     this.createdAt,
     this.updatedAt,
  });

  factory VehiculoDetalleModel.fromJson(Map<String, dynamic> json) {
    return VehiculoDetalleModel(
      id: json['id'],
      vehiculo_id: json['vehiculo_id'],
      detalle_id: json['detalle_id'],
      estado: json['estado'] == 1 ? true : false,
      valor: json['valor'],      
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehiculo_id': vehiculo_id,
      'detalle_id': detalle_id,
      'estado': estado == true ? 1 : 0,
      'valor': valor,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
