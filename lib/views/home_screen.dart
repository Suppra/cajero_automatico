import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/retiro_controller.dart';
import '../models/retiro_model.dart';
import 'retiro_nequi_screen.dart';
import 'retiro_ahorro_mano_screen.dart';
import 'retiro_cuenta_ahorro_screen.dart';

/// Pantalla principal del cajero automático
/// Permite seleccionar el tipo de retiro deseado
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: SafeArea(
        child: Consumer<RetiroController>(
          builder: (context, controller, child) {
            return Column(
              children: [
                // Header del cajero
                _buildHeader(),
                
                // Espacio principal
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildWelcomeMessage(),
                        const SizedBox(height: 30),
                        _buildTipoRetiroOptions(context, controller),
                        const Spacer(),
                        _buildFooter(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Construye el header del cajero
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(
            Icons.account_balance,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CAJERO AUTOMÁTICO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Universidad Popular del César',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: Colors.white, size: 8),
                const SizedBox(width: 5),
                Text(
                  'ACTIVO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Mensaje de bienvenida
  Widget _buildWelcomeMessage() {
    return Column(
      children: [
        Icon(
          Icons.monetization_on,
          size: 60,
          color: Colors.blue[700],
        ),
        const SizedBox(height: 15),
        Text(
          '¡Bienvenido!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Seleccione el tipo de retiro que desea realizar',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Opciones de tipo de retiro
  Widget _buildTipoRetiroOptions(BuildContext context, RetiroController controller) {
    return Column(
      children: [
        // Retiro NEQUI
        _buildRetiroOption(
          context: context,
          icon: Icons.phone_android,
          titulo: 'NEQUI - Retiro con Celular',
          descripcion: 'Retiro usando número de celular\n(10 dígitos)',
          color: Colors.purple,
          onTap: () => _navigateToRetiro(context, TipoRetiro.nequi),
        ),
        
        const SizedBox(height: 20),
        
        // Retiro Ahorro a la Mano
        _buildRetiroOption(
          context: context,
          icon: Icons.savings,
          titulo: 'Ahorro a la Mano',
          descripcion: 'Retiro con número de ahorro\n(11 dígitos, inicia 0 o 1)',
          color: Colors.orange,
          onTap: () => _navigateToRetiro(context, TipoRetiro.ahorroMano),
        ),
        
        const SizedBox(height: 20),
        
        // Retiro Cuenta de Ahorros
        _buildRetiroOption(
          context: context,
          icon: Icons.account_balance_wallet,
          titulo: 'Cuenta de Ahorros',
          descripcion: 'Retiro con cuenta de ahorros\n(11 dígitos)',
          color: Colors.green,
          onTap: () => _navigateToRetiro(context, TipoRetiro.cuentaAhorro),
        ),
      ],
    );
  }

  /// Widget para cada opción de retiro
  Widget _buildRetiroOption({
    required BuildContext context,
    required IconData icon,
    required String titulo,
    required String descripcion,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 30,
                color: color,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    descripcion,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// Footer con información adicional
  Widget _buildFooter() {
    return Column(
      children: [
        Divider(color: Colors.grey[300]),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoItem(
              icon: Icons.schedule,
              texto: '24/7\nServicio',
            ),
            _buildInfoItem(
              icon: Icons.security,
              texto: 'Seguro\nConfiable',
            ),
            _buildInfoItem(
              icon: Icons.money,
              texto: 'Sin\nComisión',
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          'Proyecto Académico - Sistemas de Información',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  /// Widget para información en el footer
  Widget _buildInfoItem({required IconData icon, required String texto}) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue[700], size: 24),
        const SizedBox(height: 5),
        Text(
          texto,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Navega a la pantalla de retiro específica
  void _navigateToRetiro(BuildContext context, TipoRetiro tipo) {
    final controller = Provider.of<RetiroController>(context, listen: false);
    controller.seleccionarTipoRetiro(tipo);

    Widget screen;
    switch (tipo) {
      case TipoRetiro.nequi:
        screen = const RetiroNequiScreen();
        break;
      case TipoRetiro.ahorroMano:
        screen = const RetiroAhorroManoScreen();
        break;
      case TipoRetiro.cuentaAhorro:
        screen = const RetiroCuentaAhorroScreen();
        break;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}