import 'package:equatable/equatable.dart';

class AgregarBebidaState extends Equatable {
    final String nombre;
    final NombreStatus nombreStatus;
    final String nombreMessage;
    final String descripcion;
    final double precio;
    final PrecioStatus precioStatus;
    final String precioMessage;
    final bool disponible;
    final String size;
    final AgregarBebidaStatus agregarBebidaStatus;
    final String errorMessage;

    const AgregarBebidaState({
        this.nombre = '',
        this.nombreStatus = NombreStatus.initial,
        this.nombreMessage = '',
        this.descripcion = '',
        this.precio = 0.0,
        this.precioStatus = PrecioStatus.initial,
        this.precioMessage = '',
        this.disponible = true,
        this.size = '',
        this.agregarBebidaStatus = AgregarBebidaStatus.initial,
        this.errorMessage = '',
    });

    AgregarBebidaState copyWith({
        String? nombre,
        NombreStatus? nombreStatus,
        String? nombreMessage,
        String? descripcion,
        double? precio,
        PrecioStatus? precioStatus,
        String? precioMessage,
        bool? disponible,
        String? size,
        AgregarBebidaStatus? agregarBebidaStatus,
        String? errorMessage,
    }) {
        return AgregarBebidaState(
            nombre: nombre ?? this.nombre,
            nombreStatus: nombreStatus ?? this.nombreStatus,
            nombreMessage: nombreMessage ?? this.nombreMessage,
            descripcion: descripcion ?? this.descripcion,
            precio: precio ?? this.precio,
            precioStatus: precioStatus ?? this.precioStatus,
            precioMessage: precioMessage ?? this.precioMessage,
            disponible: disponible ?? this.disponible,
            size: size ?? this.size,
            agregarBebidaStatus: agregarBebidaStatus ?? this.agregarBebidaStatus,
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
    size,
    agregarBebidaStatus,
    errorMessage,
    ];
}

enum NombreStatus { initial, valid, invalid }
enum PrecioStatus { initial, valid, invalid }
enum AgregarBebidaStatus { initial, loading, success, failure }