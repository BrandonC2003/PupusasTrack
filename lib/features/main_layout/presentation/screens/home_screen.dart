import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pupusas_track/core/routes/app_routes.dart';
import 'package:pupusas_track/core/themes/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // Contenido principal con scroll
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cards de estadísticas (fuera del header)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: _buildStatsCards(),
                  ),
                  
                  // Título de accesos rápidos
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Accesos Rápidos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Grid de accesos rápidos
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildQuickAccessGrid(context),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Si el ancho es pequeño, usar Column, sino Row
      if (constraints.maxWidth < 600) {
        return Column(
          children: [
            _buildStatCard(
              title: 'Ventas Hoy',
              value: '\$50',
              icon: Icons.trending_up,
              backgroundColor: Colors.white,
              iconColor: AppTheme.verdeComal,
            ),
            
            const SizedBox(height: 16),
            
            _buildStatCard(
              title: 'Pedidos',
              value: '23',
              icon: Icons.shopping_cart,
              backgroundColor: Colors.white,
              iconColor: AppTheme.rojoTomate,
            ),
          ],
        );
      } else {
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildStatCard(
                title: 'Ventas Hoy',
                value: '\$50',
                icon: Icons.trending_up,
                backgroundColor: Colors.white,
                iconColor: AppTheme.verdeComal,
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              flex: 2,
              child: _buildStatCard(
                title: 'Pedidos',
                value: '23',
                icon: Icons.shopping_cart,
                backgroundColor: Colors.white,
                iconColor: AppTheme.rojoTomate,
              ),
            ),
          ],
        );
      }
    },
  );
}

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05), // Actualizado withValues
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1), // Actualizado withValues
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.9, // Reducido para dar más altura y evitar overflow
      children: [
        _buildQuickAccessCard(
          title: 'Catálogo',
          subtitle: 'Pupusas y bebidas',
          icon: Icons.restaurant_menu,
          backgroundColor: AppTheme.azulSalvador.withValues(alpha: 0.1), // Actualizado
          iconColor: AppTheme.azulSalvador,
          onTap: () => context.go(AppRoutes.catalogo),
        ),
        
        _buildQuickAccessCard(
          title: 'Informes',
          subtitle: 'Informes avanzados',
          icon: Icons.bar_chart_sharp,
          backgroundColor: AppTheme.doradoMaiz.withValues(alpha: 0.1), // Actualizado
          iconColor: AppTheme.doradoMaiz,
          onTap: () => context.go(AppRoutes.informes),
        ),
        
        _buildQuickAccessCard(
          title: 'Pedidos',
          subtitle: 'Gestión de pedidos',
          icon: Icons.receipt_long,
          backgroundColor: AppTheme.verdeComal.withValues(alpha: 0.1), // Actualizado
          iconColor: AppTheme.verdeComal,
          onTap: () => context.go(AppRoutes.pedidos),
        ),
        
        _buildQuickAccessCard(
          title: 'Día a Día',
          subtitle: 'Registro diario',
          icon: Icons.attach_money,
          backgroundColor: AppTheme.rojoTomate.withValues(alpha: 0.1), // Actualizado
          iconColor: AppTheme.rojoTomate,
          onTap: (){
            context.go(AppRoutes.registroDiario);
          },
        ),
      ],
    );
  }

  Widget _buildQuickAccessCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1), // Actualizado withValues
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16), // Reducido de 20 a 16
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono con fondo circular
              Container(
                width: 48, // Reducido de 56 a 48
                height: 48, // Reducido de 56 a 48
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24, // Reducido de 28 a 24
                ),
              ),
              
              const SizedBox(height: 12), // Reducido de 16 a 12
              
              // Título
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15, // Reducido de 16 a 15
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 2), // Reducido de 4 a 2
              
              // Subtítulo
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11, // Reducido de 12 a 11
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}