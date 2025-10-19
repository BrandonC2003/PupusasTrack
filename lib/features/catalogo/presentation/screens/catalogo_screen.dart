import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pupusas_track/core/routes/app_routes.dart';
import 'package:pupusas_track/core/themes/app_theme.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/catalogo/catalogo_bloc.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/catalogo/catalogo_event.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/catalogo/catalogo_state.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/entities/catalogo_producto_entity.dart';
import 'package:pupusas_track/features/material/domain/entities/material_entity.dart';
import 'package:pupusas_track/injection.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CatalogoBloc>()..add(CargarProductos()),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: _buildAppBar(context),
        body: BlocBuilder<CatalogoBloc, CatalogoState>(
          builder: (context, state) {
            if (state is CatalogoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CatalogoLoaded) {
              return Column(
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
                        _buildPupusasTab(state.pupusas),
                        _buildBebidasTab(state.bebidas),
                        _buildMaterialesTab(state.materiales),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is CatalogoError) {
              return Center(child: Text("Error: ${state.errorMessage}"));
            }
            return Container();
          },
        ),
        floatingActionButton: _buildCreateButtons(context),
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
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
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

  Widget _buildPupusasTab(List<CatalogoProductoEntity> pupusas) {
    List<CatalogoProductoEntity> filteredPupusas = pupusas
        .where(
          (pupusa) =>
              pupusa.nombre.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredPupusas.length,
      itemBuilder: (context, index) {
        return _buildPupusaCard(filteredPupusas[index]);
      },
    );
  }

  Widget _buildBebidasTab(List<CatalogoProductoEntity> bebidas) {
    List<CatalogoProductoEntity> filteredBebidas = bebidas
        .where(
          (bebida) =>
              bebida.nombre.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredBebidas.length,
      itemBuilder: (context, index) {
        return _buildBebidaCard(filteredBebidas[index]);
      },
    );
  }

  Widget _buildMaterialesTab(List<MaterialEntity> materiales) {
    List<MaterialEntity> filteredMateriales = materiales
        .where(
          (material) => material.nombre.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredMateriales.length,
      itemBuilder: (context, index) {
        return _buildMaterialCard(filteredMateriales[index]);
      },
    );
  }

  Widget _buildPupusaCard(CatalogoProductoEntity pupusa) {
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
                  // nombre: permitir que el texto ajuste y se trunque si es necesario
                  AutoSizeText(
                    pupusa.nombre,
                    maxLines: 2,
                    minFontSize: 10,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${pupusa.precio.toStringAsFixed(2)}',
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
                  icon: Icon(
                    Icons.edit,
                    color: AppTheme.azulSalvador,
                    size: 20,
                  ),
                  onPressed: () => _editItem(pupusa),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: AppTheme.rojoTomate,
                    size: 20,
                  ),
                  onPressed: () => _deleteItem(pupusa.id, pupusa.nombre),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBebidaCard(CatalogoProductoEntity bebida) {
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
                    bebida.nombre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    bebida.size ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${bebida.precio.toStringAsFixed(2)}',
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
                  icon: Icon(
                    Icons.edit,
                    color: AppTheme.azulSalvador,
                    size: 20,
                  ),
                  onPressed: () => _editItem(bebida),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: AppTheme.rojoTomate,
                    size: 20,
                  ),
                  onPressed: () => _deleteItem(bebida.id, bebida.nombre),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialCard(MaterialEntity pupusa) {
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
                color: AppTheme.rojoTomate.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('🍚', style: TextStyle(fontSize: 28)),
              ),
            ),

            const SizedBox(width: 16),

            // Información del material
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // nombre: usar AutoSizeText para ajustar en espacios pequeños
                  AutoSizeText(
                    pupusa.nombre,
                    maxLines: 2,
                    minFontSize: 10,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pupusa.descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14,
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
                  icon: Icon(
                    Icons.edit,
                    color: AppTheme.azulSalvador,
                    size: 20,
                  ),
                  onPressed: () => _editItem(pupusa),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: AppTheme.rojoTomate,
                    size: 20,
                  ),
                  onPressed: () => _deleteItem(pupusa.id!, pupusa.nombre),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButtons(BuildContext context) {
    return BlocBuilder<CatalogoBloc, CatalogoState>(
      builder: (context, state) {
        final catalogoBloc = context.read<CatalogoBloc>();
        final router = GoRouter.of(context);
        return FloatingActionButton(
          onPressed: () => showModalBottomSheet(
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
                    onTap: () async {
                      context.pop();
                      final result = await router.push<bool>(AppRoutes.agregarProducto);
                      if (result == true) catalogoBloc.add(CargarProductos());
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
                    onTap: () async {
                      context.pop();
                      final result = await router.push<bool>(AppRoutes.agregarMaterial);
                      if (result == true) catalogoBloc.add(CargarProductos());
                    },
                  ),

                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.rojoTomate.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('🍚', style: TextStyle(fontSize: 20)),
                    ),
                    title: const Text('Agregar Material'),
                    subtitle: const Text('Nuevo material al catálogo'),
                    onTap: () async {
                      context.pop();
                      final result = await router.push<bool>(AppRoutes.agregarMaterial);
                      if (result == true) catalogoBloc.add(CargarProductos());
                    },
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: AppTheme.azulSalvador,
          child: const Icon(Icons.add, color: Colors.white),
        );
      },
    );
  }

  void _editItem(dynamic item) {
    // Implementar edición
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Editando ${item.name}')));
  }

  void _deleteItem(String id, String name) {
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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$name eliminado')));
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
