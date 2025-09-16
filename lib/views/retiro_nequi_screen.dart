import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../controllers/retiro_controller.dart';
import '../models/retiro_model.dart';
import 'resultado_retiro_screen.dart';

/// Pantalla para retiro tipo NEQUI
/// Maneja retiros por número de celular con clave temporal visible
class RetiroNequiScreen extends StatefulWidget {
  const RetiroNequiScreen({Key? key}) : super(key: key);

  @override
  State<RetiroNequiScreen> createState() => _RetiroNequiScreenState();
}

class _RetiroNequiScreenState extends State<RetiroNequiScreen> {
  final _celularController = TextEditingController();
  final _montoController = TextEditingController();

  String _claveGenerada = '';
  bool _claveVisible = false;
  Timer? _timerClave;
  int _segundosRestantes = 0;

  @override
  void dispose() {
    _celularController.dispose();
    _montoController.dispose();
    _timerClave?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: const Text('Retiro NEQUI'),
        backgroundColor: Colors.purple[700],
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
                  if (_claveVisible) _buildClaveTemporalCard(),
                  const SizedBox(height: 20),
                  _buildMontosPredefindios(controller),
                  const SizedBox(height: 30),
                  _buildBotones(controller),
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
        color: Colors.purple[100],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.purple[300]!, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.phone_android, size: 40, color: Colors.purple[700]),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Retiro NEQUI',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '• Número de celular de 10 dígitos\n• Clave temporal visible por 60 segundos\n• Se agrega "0" al inicio del número',
                  style: TextStyle(fontSize: 14, color: Colors.purple[600]),
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
          // Campo número de celular
          Text(
            'Número de Celular',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _celularController,
            keyboardType: TextInputType.number,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: '3001234567',
              prefixIcon: Icon(Icons.phone, color: Colors.purple[600]),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.purple[600]!, width: 2),
              ),
              counterText: '${_celularController.text.length}/10',
            ),
            onChanged: (value) {
              controller.actualizarNumeroIdentificacion(value);
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
              prefixIcon: Icon(Icons.money, color: Colors.purple[600]),
              prefixText: '\$ ',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.purple[600]!, width: 2),
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

  /// Card que muestra la clave temporal
  Widget _buildClaveTemporalCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.purple[600]!, Colors.purple[800]!]),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.lock_clock, color: Colors.white, size: 30),
              const SizedBox(width: 15),
              Text(
                'Clave Temporal',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_segundosRestantes}s',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Text(
                  'Su clave temporal es:',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 10),
                Text(
                  _claveGenerada,
                  style: TextStyle(
                    color: Colors.purple[800],
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Memorice esta clave, desaparecerá en $_segundosRestantes segundos',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
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
                  color: esSeleccionado ? Colors.purple[600] : Colors.white,
                  border: Border.all(
                    color: esSeleccionado ? Colors.purple[600]! : Colors.purple[300]!,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  '\$${_formatearMonto(monto)}',
                  style: TextStyle(
                    color: esSeleccionado ? Colors.white : Colors.purple[600],
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

  /// Botones de acción
  Widget _buildBotones(RetiroController controller) {
    return Column(
      children: [
        // Botón generar clave
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _puedeGenerarClave(controller) ? _generarClave : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.key),
                const SizedBox(width: 10),
                Text(
                  'Generar Clave Temporal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Botón procesar retiro
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _puedeRetirar(controller) ? () => _procesarRetiro(controller) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[600],
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
        ),
      ],
    );
  }

  /// Verifica si se puede generar la clave
  bool _puedeGenerarClave(RetiroController controller) {
    return _celularController.text.length == 10 &&
        controller.monto > 0 &&
        !controller.procesandoRetiro &&
        !_claveVisible;
  }

  /// Verifica si se puede procesar el retiro
  bool _puedeRetirar(RetiroController controller) {
    return _celularController.text.length == 10 &&
        controller.monto > 0 &&
        _claveVisible &&
        !controller.procesandoRetiro;
  }

  /// Genera la clave temporal
  void _generarClave() {
    final controller = Provider.of<RetiroController>(context, listen: false);
    _claveGenerada = controller.generarClaveTemporalNequi();
    _claveVisible = true;
    _segundosRestantes = 60;

    // Iniciar temporizador
    _timerClave = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _segundosRestantes--;
        if (_segundosRestantes <= 0) {
          _claveVisible = false;
          _claveGenerada = '';
          timer.cancel();
        }
      });
    });

    setState(() {});
  }

  /// Procesa el retiro
  Future<void> _procesarRetiro(RetiroController controller) async {
    final exito = await controller.procesarRetiro();

    if (exito) {
      // Navegar a pantalla de resultado
      if (mounted) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => const ResultadoRetiroScreen()));
      }
    }
  }

  /// Formatea monto con separadores de miles
  String _formatearMonto(double monto) {
    return monto
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},');
  }
}
