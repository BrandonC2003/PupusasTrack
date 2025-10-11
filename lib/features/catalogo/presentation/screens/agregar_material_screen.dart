
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pupusas_track/core/themes/app_theme.dart';

class AgregarMaterialScreen extends StatefulWidget {
  const AgregarMaterialScreen({super.key});

  @override
  State<AgregarMaterialScreen> createState() => _AgregarMaterialScreenState();
}

class _AgregarMaterialScreenState extends State<AgregarMaterialScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  
  bool _disponible = true;
  List<Descuento> _descuentos = [];

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.grey.shade700),
          onPressed: () => _showExitConfirmation(context),
        ),
        title: const Text(
          'Nueva Pupusa',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Formulario scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icono de pupusa decorativo
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.doradoMaiz.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('🫓', style: TextStyle(fontSize: 50)),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Sección: Información básica
                    _buildSectionTitle('Información Básica'),
                    const SizedBox(height: 16),
                    
                    // Campo: Nombre
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la pupusa',
                        hintText: 'Ej: Revueltas',
                        prefixIcon: Icon(Icons.restaurant_menu),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre es obligatorio';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Campo: Descripción
                    TextFormField(
                      controller: _descripcionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        hintText: 'Describe los ingredientes...',
                        helperText: 'Opcional - Describe los ingredientes o características',
                        helperMaxLines: 2,
                        prefixIcon: Icon(Icons.description),
                        alignLabelWithHint: true,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Campo: Precio unitario
                    TextFormField(
                      controller: _precioController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Precio unitario',
                        hintText: '1.50',
                        prefixIcon: Icon(Icons.attach_money),
                        prefixText: '\$ ',
                        suffixText: 'USD',
                        helperText: 'Precio por unidad',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El precio es obligatorio';
                        }
                        final precio = double.tryParse(value);
                        if (precio == null || precio <= 0) {
                          return 'Ingresa un precio válido';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Sección: Disponibilidad
                    _buildSectionTitle('Disponibilidad'),
                    const SizedBox(height: 12),
                    
                    Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: SwitchListTile(
                        value: _disponible,
                        onChanged: (value) {
                          setState(() {
                            _disponible = value;
                          });
                        },
                        title: const Text(
                          'Producto disponible',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          _disponible 
                              ? 'Este producto está disponible para la venta' 
                              : 'Este producto no está disponible',
                          style: TextStyle(fontSize: 12),
                        ),
                        activeColor: AppTheme.verdeComal,
                        secondary: Icon(
                          _disponible ? Icons.check_circle : Icons.cancel,
                          color: _disponible ? AppTheme.verdeComal : Colors.grey,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Sección: Descuentos por cantidad
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionTitle('Descuentos por Cantidad'),
                        TextButton.icon(
                          onPressed: _agregarDescuento,
                          icon: const Icon(Icons.add, size: 20),
                          label: const Text('Agregar'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.azulSalvador,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Lista de descuentos
                    if (_descuentos.isEmpty)
                      _buildEmptyDescuentos()
                    else
                      ..._descuentos.asMap().entries.map(
                        (entry) => _buildDescuentoCard(entry.key, entry.value),
                      ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            
            // Botones de acción fijos en la parte inferior
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildEmptyDescuentos() {
    return Card(
      elevation: 0,
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.local_offer_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'No hay descuentos configurados',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Toca "Agregar" para crear un descuento',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescuentoCard(int index, Descuento descuento) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Descuento ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: AppTheme.rojoTomate,
                    size: 20,
                  ),
                  onPressed: () => _eliminarDescuento(index),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                // Cantidad
                Expanded(
                  child: TextFormField(
                    initialValue: descuento.cantidad.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      hintText: '5',
                      prefixIcon: Icon(Icons.shopping_basket, size: 20),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (value) {
                      final cantidad = int.tryParse(value) ?? 0;
                      setState(() {
                        _descuentos[index] = Descuento(
                          cantidad: cantidad,
                          precio: descuento.precio,
                        );
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requerido';
                      }
                      final cantidad = int.tryParse(value);
                      if (cantidad == null || cantidad <= 0) {
                        return 'Inválido';
                      }
                      return null;
                    },
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Precio
                Expanded(
                  child: TextFormField(
                    initialValue: descuento.precio.toStringAsFixed(2),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Precio',
                      hintText: '1.25',
                      prefixText: '\$ ',
                      prefixIcon: Icon(Icons.attach_money, size: 20),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (value) {
                      final precio = double.tryParse(value) ?? 0.0;
                      setState(() {
                        _descuentos[index] = Descuento(
                          cantidad: descuento.cantidad,
                          precio: precio,
                        );
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requerido';
                      }
                      final precio = double.tryParse(value);
                      if (precio == null || precio <= 0) {
                        return 'Inválido';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Información del descuento calculada
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.verdeComal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppTheme.verdeComal,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Precio total: \$${(descuento.cantidad * descuento.precio).toStringAsFixed(2)} por ${descuento.cantidad} unidades',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.verdeComal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Botón Cancelar
          Expanded(
            child: OutlinedButton(
              onPressed: () => _showExitConfirmation(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Cancelar'),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Botón Guardar
          Expanded(
            child: ElevatedButton(
              onPressed: _guardarPupusa,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }

  void _agregarDescuento() {
    setState(() {
      _descuentos.add(Descuento(cantidad: 0, precio: 0.0));
    });
  }

  void _eliminarDescuento(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar descuento'),
        content: const Text('¿Estás seguro de que quieres eliminar este descuento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _descuentos.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.rojoTomate,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _guardarPupusa() {
    if (_formKey.currentState!.validate()) {
      // Aquí implementar la lógica de guardado con BLoC
      final pupusaData = {
        'nombre': _nombreController.text,
        'descripcion': _descripcionController.text,
        'precio': double.parse(_precioController.text),
        'disponible': _disponible,
        'descuentos': _descuentos.map((d) => {
          'cantidad': d.cantidad,
          'precio': d.precio,
        }).toList(),
      };
      
      print('Guardando pupusa: $pupusaData');
      
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pupusa guardada exitosamente'),
          backgroundColor: AppTheme.verdeComal,
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // Regresar a la pantalla anterior
      Navigator.pop(context);
    }
  }

  void _showExitConfirmation(BuildContext context) {
    // Verificar si hay cambios sin guardar
    if (_nombreController.text.isNotEmpty ||
        _descripcionController.text.isNotEmpty ||
        _precioController.text.isNotEmpty ||
        _descuentos.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¿Descartar cambios?'),
          content: const Text(
            'Tienes cambios sin guardar. ¿Estás seguro de que quieres salir?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continuar editando'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
                Navigator.pop(context); // Cerrar pantalla
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.rojoTomate,
              ),
              child: const Text('Descartar'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }
}

// Modelo de descuento
class Descuento {
  final int cantidad;
  final double precio;

  Descuento({
    required this.cantidad,
    required this.precio,
  });
}