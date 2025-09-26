import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pupusas_track/core/routes/app_routes.dart';
import 'package:pupusas_track/core/themes/app_theme.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  // Datos de ejemplo - reemplazar con datos reales de BLoC o Provider
  final List<PupusaItem> _pupusas = [
    PupusaItem(id: 1, name: 'Frijol con queso', price: 1.25, isPopular: false),
    PupusaItem(id: 2, name: 'Revueltas', price: 1.50, isPopular: false),
    PupusaItem(id: 3, name: 'Queso', price: 1.00, isPopular: false),
    PupusaItem(id: 4, name: 'Queso con loroco', price: 1.75, isPopular: false),
    PupusaItem(id: 5, name: 'Pollo', price: 1.50, isPopular: false),
    PupusaItem(id: 6, name: 'Ayote', price: 1.25, isPopular: false),
    PupusaItem(id: 7, name: 'Camarón', price: 2.00, isPopular: false),
    PupusaItem(id: 8, name: 'Jalapeño', price: 1.35, isPopular: false),
  ];

  final List<BebidaItem> _bebidas = [
    BebidaItem(id: 1, name: 'Horchata', price: 0.75, size: 'Vaso'),
    BebidaItem(id: 2, name: 'Tamarindo', price: 0.75, size: 'Vaso'),
    BebidaItem(id: 3, name: 'Coca Cola', price: 1.00, size: '355ml'),
    BebidaItem(id: 4, name: 'Agua', price: 0.50, size: '500ml'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length:3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // Barra de búsqueda
          _buildSearchBar(),
          
          // Tabs
          _buildTabBar(),
          
          // Contenido de tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPupusasTab(),
                _buildBebidasTab(),
                _buildPupusasTab()
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context),
        backgroundColor: AppTheme.azulSalvador,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.grey.shade700),
        onPressed: () => context.go(AppRoutes.home),
      ),
      title: const Text(
        'Catálogo',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.center,
        controller: _tabController,
        labelColor: AppTheme.azulSalvador,
        unselectedLabelColor: Colors.grey.shade600,
        indicatorColor: AppTheme.azulSalvador,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'Pupusas'),
          Tab(text: 'Bebidas'),
          Tab(text: 'Materiales'),
        ],
      ),
    );
  }

  Widget _buildPupusasTab() {
    List<PupusaItem> filteredPupusas = _pupusas.where((pupusa) =>
        pupusa.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredPupusas.length,
      itemBuilder: (context, index) {
        return _buildPupusaCard(filteredPupusas[index]);
      },
    );
  }

  Widget _buildBebidasTab() {
    List<BebidaItem> filteredBebidas = _bebidas.where((bebida) =>
        bebida.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredBebidas.length,
      itemBuilder: (context, index) {
        return _buildBebidaCard(filteredBebidas[index]);
      },
    );
  }

  Widget _buildPupusaCard(PupusaItem pupusa) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Emoji de pupusa
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.doradoMaiz.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('🫓', style: TextStyle(fontSize: 28)),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Información de la pupusa
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        pupusa.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      if (pupusa.isPopular) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.rojoTomate.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Popular',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.rojoTomate,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${pupusa.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.verdeComal,
                    ),
                  ),
                ],
              ),
            ),
            
            // Botones de acción
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: AppTheme.azulSalvador, size: 20),
                  onPressed: () => _editItem(pupusa),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: AppTheme.rojoTomate, size: 20),
                  onPressed: () => _deleteItem(pupusa.id, pupusa.name),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBebidaCard(BebidaItem bebida) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Emoji de bebida
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.azulSalvador.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('🥤', style: TextStyle(fontSize: 28)),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Información de la bebida
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bebida.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    bebida.size,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${bebida.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.verdeComal,
                    ),
                  ),
                ],
              ),
            ),
            
            // Botones de acción
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: AppTheme.azulSalvador, size: 20),
                  onPressed: () => _editItem(bebida),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: AppTheme.rojoTomate, size: 20),
                  onPressed: () => _deleteItem(bebida.id, bebida.name),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.doradoMaiz.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('🫓', style: TextStyle(fontSize: 20)),
              ),
              title: const Text('Agregar Pupusa'),
              subtitle: const Text('Nuevo tipo de pupusa'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/add-pupusa');
              },
            ),
            
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.azulSalvador.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('🥤', style: TextStyle(fontSize: 20)),
              ),
              title: const Text('Agregar Bebida'),
              subtitle: const Text('Nueva bebida al menú'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/add-bebida');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editItem(dynamic item) {
    // Implementar edición
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editando ${item.name}')),
    );
  }

  void _deleteItem(int id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar elemento'),
        content: Text('¿Estás seguro de que quieres eliminar "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implementar eliminación
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$name eliminado')),
              );
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
}

// Modelos de datos
class PupusaItem {
  final int id;
  final String name;
  final double price;
  final bool isPopular;

  PupusaItem({
    required this.id,
    required this.name,
    required this.price,
    required this.isPopular,
  });
}

class BebidaItem {
  final int id;
  final String name;
  final double price;
  final String size;

  BebidaItem({
    required this.id,
    required this.name,
    required this.price,
    required this.size,
  });
}