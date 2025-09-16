import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controllers/retiro_controller.dart';
import 'resultado_retiro_screen.dart';

/// Pantalla para retiro tipo Ahorro a la Mano
/// Maneja retiros con número de 11 dígitos que inicia con 0 o 1, segundo dígito 3
class RetiroAhorroManoScreen extends StatefulWidget {
  const RetiroAhorroManoScreen({Key? key}) : super(key: key);

  @override
  State<RetiroAhorroManoScreen> createState() => _RetiroAhorroManoScreenState();
}

class _RetiroAhorroManoScreenState extends State<RetiroAhorroManoScreen> {
  final _numeroController = TextEditingController();
  final _claveController = TextEditingController();
  final _montoController = TextEditingController();

  @override
  void dispose() {
    _numeroController.dispose();
    _claveController.dispose();
    _montoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text('Ahorro a la Mano'),
        backgroundColor: Colors.orange[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<RetiroController>(
          builder: (context, controller, child) {
            // Verificar si debe regresar al inicio por error de múltiplo
            if (controller.debeRegresarAlInicio) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                controller.resetearRegresarAlInicio();
                Navigator.of(context).popUntil((route) => route.isFirst);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Proceso cancelado. ${controller.mensajeError ?? "Intente nuevamente."}',
                    ),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              });
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 20),
                  _buildFormulario(controller),
                  const SizedBox(height: 20),
                  _buildMontosPredefindios(controller),
                  const SizedBox(height: 30),
                  _buildBotonProcesar(controller),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Card con información del tipo de retiro
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange[300]!, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.savings, size: 40, color: Colors.orange[700]),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ahorro a la Mano',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '• Vector de 11 dígitos\n• Primer dígito: 0 o 1 (no 2-9)\n• Segundo dígito: obligatorio 3\n• Clave: 4 dígitos ocultos',
                  style: TextStyle(fontSize: 14, color: Colors.orange[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Formulario principal
  Widget _buildFormulario(RetiroController controller) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campo vector de ahorro a la mano
          Text(
            'Vector de Ahorro a la Mano (11 dígitos)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _numeroController,
            keyboardType: TextInputType.number,
            maxLength: 11,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: '03001234567',
              prefixIcon: Icon(Icons.account_balance, color: Colors.orange[600]),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.orange[600]!, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              counterText: '${_numeroController.text.length}/11',
              helperText: '1er dígito: 0 o 1 | 2do dígito: obligatorio 3',
              helperMaxLines: 2,
            ),
            onChanged: (value) {
              controller.actualizarNumeroIdentificacion(value);
              setState(() {});
            },
          ),

          const SizedBox(height: 25),

          // Campo clave (siempre oculta)
          Text(
            'Clave de 4 Dígitos (No visible en pantalla)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _claveController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true, // Siempre oculta
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: '••••',
              prefixIcon: Icon(Icons.security, color: Colors.orange[600]),
              suffixIcon: Icon(Icons.visibility_off, color: Colors.grey[400]),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.orange[600]!, width: 2),
              ),
              counterText: '${_claveController.text.length}/4',
              helperText: 'Clave secreta de 4 dígitos',
            ),
            onChanged: (value) {
              controller.actualizarClave(value);
              setState(() {});
            },
          ),

          const SizedBox(height: 25),

          // Campo monto
          Text(
            'Monto a Retirar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _montoController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: '50000',
              prefixIcon: Icon(Icons.money, color: Colors.orange[600]),
              prefixText: '\$ ',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.orange[600]!, width: 2),
              ),
            ),
            onChanged: (value) {
              final monto = double.tryParse(value) ?? 0.0;
              controller.actualizarMonto(monto);
            },
            onEditingComplete: () {
              controller.validarMontoFinal();
            },
          ),

          // Mostrar errores
          if (controller.mensajeError != null) ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[600]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(controller.mensajeError!, style: TextStyle(color: Colors.red[700])),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Botones con montos predefinidos
  Widget _buildMontosPredefindios(RetiroController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Montos Disponibles',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: controller.montosPredefindios.map((monto) {
            final esSeleccionado = controller.monto == monto;
            return GestureDetector(
              onTap: () {
                controller.actualizarMonto(monto);
                _montoController.text = monto.toStringAsFixed(0);
                controller.validarMontoFinal();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: esSeleccionado ? Colors.orange[600] : Colors.white,
                  border: Border.all(
                    color: esSeleccionado ? Colors.orange[600]! : Colors.orange[300]!,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  '\$${_formatearMonto(monto)}',
                  style: TextStyle(
                    color: esSeleccionado ? Colors.white : Colors.orange[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Botón para procesar retiro
  Widget _buildBotonProcesar(RetiroController controller) {
    final puedeRetirar =
        _numeroController.text.length == 11 &&
        _claveController.text.length == 4 &&
        controller.monto > 0 &&
        !controller.procesandoRetiro;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: puedeRetirar ? () => _procesarRetiro(controller) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange[600],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: controller.procesandoRetiro
            ? const CircularProgressIndicator(color: Colors.white)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.money),
                  const SizedBox(width: 10),
                  Text(
                    'Procesar Retiro',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }

  /// Procesa el retiro
  Future<void> _procesarRetiro(RetiroController controller) async {
    final exito = await controller.procesarRetiro();

    if (exito && mounted) {
      // Navegar a pantalla de resultado rica
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => const ResultadoRetiroScreen()));
    }
  }

  /// Formatea monto con separadores de miles
  String _formatearMonto(double monto) {
    return monto
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},');
  }
}
