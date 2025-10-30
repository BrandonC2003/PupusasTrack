import 'package:equatable/equatable.dart';

class ActualizarProductoState extends Equatable {
    final String id;
    final String nombre;
    final NombreStatus nombreStatus;
    final String nombreMessage;
    final String descripcion;
    final double precio;
    final PrecioStatus precioStatus;
    final String precioMessage;
    final bool disponible;
    final List<Descuento> descuentos;
    final ActualizarProductoStatus actualizarProductoStatus;
    final String errorMessage;

    const ActualizarProductoState({
        this.id = '',
        this.nombre = '',
        this.nombreStatus = NombreStatus.initial,
        this.nombreMessage = '',
        this.descripcion = '',
        this.precio = 0.0,
        this.precioStatus = PrecioStatus.initial,
        this.precioMessage = '',
        this.disponible = true,
        this.descuentos = const [],
        this.actualizarProductoStatus = ActualizarProductoStatus.initial,
        this.errorMessage = '',
    });

    ActualizarProductoState copyWith({
        String? id,
        String? nombre,
        NombreStatus? nombreStatus,
        String? nombreMessage,
        String? descripcion,
        double? precio,
        PrecioStatus? precioStatus,
        String? precioMessage,
        bool? disponible,
        List<Descuento>? descuentos,
        ActualizarProductoStatus? actualizarProductoStatus,
        String? errorMessage,
    }) {
        return ActualizarProductoState(
            id: id ?? this.id,
            nombre: nombre ?? this.nombre,
            nombreStatus: nombreStatus ?? this.nombreStatus,
            nombreMessage: nombreMessage ?? this.nombreMessage,
            descripcion: descripcion ?? this.descripcion,
            precio: precio ?? this.precio,
            precioStatus: precioStatus ?? this.precioStatus,
            precioMessage: precioMessage ?? this.precioMessage,
            disponible: disponible ?? this.disponible,
            descuentos: descuentos ?? this.descuentos,
            actualizarProductoStatus: actualizarProductoStatus ?? this.actualizarProductoStatus,
            errorMessage: errorMessage ?? this.errorMessage,
        );
    }

    @override
    List<Object?> get props => [
    nombre,
    nombreStatus,
    nombreMessage,
    descripcion,
    precio,
    precioStatus,
    precioMessage,
    disponible,
    descuentos,
    actualizarProductoStatus,
    errorMessage,
    ];
}

class Descuento extends Equatable {
  final String id;
  final int cantidad;
  final double precio;
  final bool valid;
  final String? errorMessage;

  const Descuento({
    required this.id,
    this.cantidad = 0,
    this.precio = 0.0,
    this.valid = false,
    this.errorMessage,
  });

  Descuento copyWith({
    String? id,
    int? cantidad,
    double? precio,
    bool? valid,
    String? errorMessage,
  }) {
    return Descuento(
      id: id ?? this.id,
      cantidad: cantidad ?? this.cantidad,
      precio: precio ?? this.precio,
      valid: valid ?? this.valid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [id, cantidad, precio, valid, errorMessage];
}

enum NombreStatus { initial, valid, invalid }
enum PrecioStatus { initial, valid, invalid }
enum ActualizarProductoStatus { initial, loading, success, failure }