class DetalleModel {
  late int? id;
  late String? nombre;
  late String? descripcion;
  late bool? valor;
  late DateTime? createdAt;
  late DateTime? updatedAt;

  DetalleModel({
     this.id,
     this.nombre,
     this.descripcion,
     this.valor,
     this.createdAt,
     this.updatedAt,
  });

  factory DetalleModel.fromJson(Map<String, dynamic> json) {
    return DetalleModel(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      valor: json['valor'] == 1 ? true : false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'valor': valor == true ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
