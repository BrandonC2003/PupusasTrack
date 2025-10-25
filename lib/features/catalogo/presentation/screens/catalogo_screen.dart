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
      actions: [
        BlocBuilder<CatalogoBloc, CatalogoState>(
          builder: (context, state) {
            if (state is CatalogoLoaded) {
              return IconButton(
                icon: Icon(Icons.search, color: Colors.grey.shade700),
                onPressed: () {
                  final state = context.read<CatalogoBloc>().state;
                  if (state is CatalogoLoaded) {
                    showSearch(
                      context: context,
                      delegate: CatalogoSearchDelegate(
                        pupusas: state.pupusas,
                        bebidas: state.bebidas,
                        materiales: state.materiales,
                        onToggleStatus: _toggleItemStatus,
                        onEditItem: _editItem,
                      ),
                    );
                  }
                },
              );
            }
            return Container();
          },
        ),
      ],
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
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      itemCount: pupusas.length,
      itemBuilder: (context, index) {
        return _buildPupusaCard(pupusas[index]);
      },
    );
  }

  Widget _buildBebidasTab(List<CatalogoProductoEntity> bebidas) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      itemCount: bebidas.length,
      itemBuilder: (context, index) {
        return _buildBebidaCard(bebidas[index]);
      },
    );
  }

  Widget _buildMaterialesTab(List<MaterialEntity> materiales) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
      itemCount: materiales.length,
      itemBuilder: (context, index) {
        return _buildMaterialCard(materiales[index]);
      },
    );
  }

  Widget _buildPupusaCard(CatalogoProductoEntity pupusa) {
    return BlocBuilder<CatalogoBloc, CatalogoState>(
      builder: (context, state) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _editItem(pupusa),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                  Switch(
                    value: pupusa.disponible,
                    onChanged: (value) => _toggleItemStatus(pupusa.id, value),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBebidaCard(CatalogoProductoEntity bebida) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _editItem(bebida),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
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
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
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
              Switch(
                value: bebida.disponible,
                onChanged: (value) => _toggleItemStatus(bebida.id, value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialCard(MaterialEntity material) {
    return BlocBuilder<CatalogoBloc, CatalogoState>(
      builder: (context, state) {
        final catalogoBloc = context.read<CatalogoBloc>();
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              final result = await context.push<bool>(
                AppRoutes.actualizarMaterial,
                extra: material,
              );
              if (result == true) {
                catalogoBloc.add(CargarProductos());
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          material.nombre,
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
                          material.descripcion,
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
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: AppTheme.rojoTomate,
                      size: 20,
                    ),
                    onPressed: () {
                      /* Implementar eliminación de material */
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
                      final result = await router.push<bool>(
                        AppRoutes.agregarProducto,
                      );
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
                      final result = await router.push<bool>(
                        AppRoutes.agregarBebida,
                      );
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
                      final result = await router.push<bool>(
                        AppRoutes.agregarMaterial,
                      );
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
    if (item is CatalogoProductoEntity) {
      context.push('${AppRoutes.agregarBebida}/${item.id}');
    } else if (item is MaterialEntity) {
      context.push<bool>(AppRoutes.actualizarMaterial, extra: item);
    }
  }

  void _toggleItemStatus(String id, bool newStatus) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newStatus ? 'Elemento habilitado' : 'Elemento deshabilitado',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Search Delegate para el catálogo
class CatalogoSearchDelegate extends SearchDelegate<String> {
  final List<CatalogoProductoEntity> pupusas;
  final List<CatalogoProductoEntity> bebidas;
  final List<MaterialEntity> materiales;
  final Function(String, bool) onToggleStatus;
  final Function(dynamic) onEditItem;

  CatalogoSearchDelegate({
    required this.pupusas,
    required this.bebidas,
    required this.materiales,
    required this.onToggleStatus,
    required this.onEditItem,
  });

  @override
  String get searchFieldLabel => 'Buscar en catálogo...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.grey.shade700),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey.shade500),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Busca pupusas, bebidas o materiales',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ],
        ),
      );
    }

    final searchLower = query.toLowerCase();

    final filteredPupusas = pupusas
        .where((p) => p.nombre.toLowerCase().contains(searchLower))
        .toList();

    final filteredBebidas = bebidas
        .where((b) => b.nombre.toLowerCase().contains(searchLower))
        .toList();

    final filteredMateriales = materiales
        .where((m) => m.nombre.toLowerCase().contains(searchLower))
        .toList();

    final totalResults =
        filteredPupusas.length +
        filteredBebidas.length +
        filteredMateriales.length;

    if (totalResults == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No se encontraron resultados',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Intenta con otro término de búsqueda',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (filteredPupusas.isNotEmpty) ...[
          _buildSectionHeader('Pupusas', filteredPupusas.length),
          ...filteredPupusas.map((p) => _buildPupusaCard(p, context)),
          const SizedBox(height: 16),
        ],
        if (filteredBebidas.isNotEmpty) ...[
          _buildSectionHeader('Bebidas', filteredBebidas.length),
          ...filteredBebidas.map((b) => _buildBebidaCard(b, context)),
          const SizedBox(height: 16),
        ],
        if (filteredMateriales.isNotEmpty) ...[
          _buildSectionHeader('Materiales', filteredMateriales.length),
          ...filteredMateriales.map((m) => _buildMaterialCard(m, context)),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        '$title ($count)',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildPupusaCard(CatalogoProductoEntity pupusa, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          close(context, '');
          onEditItem(pupusa);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
              Switch(
                value: pupusa.disponible,
                onChanged: (value) {
                  onToggleStatus(pupusa.id, value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBebidaCard(CatalogoProductoEntity bebida, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          close(context, '');
          onEditItem(bebida);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
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
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
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
              Switch(
                value: bebida.disponible,
                onChanged: (value) {
                  onToggleStatus(bebida.id, value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialCard(MaterialEntity material, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          close(context, '');
          onEditItem(material);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      material.nombre,
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
                      material.descripcion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
