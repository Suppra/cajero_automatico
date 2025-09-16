import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/retiro_controller.dart';
import '../models/retiro_model.dart';
import '../models/transaccion_model.dart';

/// Pantalla que muestra el resultado del retiro
/// Incluye comprobante, billetes entregados y opciones finales
class ResultadoRetiroScreen extends StatelessWidget {
  const ResultadoRetiroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Retiro Completado'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // No mostrar botón de regreso
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<RetiroController>(
          builder: (context, controller, child) {
            final transaccion = controller.ultimaTransaccion;

            if (transaccion == null) {
              return _buildError();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildExitoHeader(),
                  const SizedBox(height: 25),
                  _buildComprobanteCard(transaccion, controller),
                  const SizedBox(height: 20),
                  _buildBilletesCard(transaccion),
                  const SizedBox(height: 20),
                  _buildRetirosRestantesCard(controller),
                  const SizedBox(height: 30),
                  _buildBotonesFinales(context, controller),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Header de éxito
  Widget _buildExitoHeader() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.green[600]!, Colors.green[800]!]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: Colors.white),
          const SizedBox(height: 15),
          Text(
            '¡Retiro Exitoso!',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Su transacción ha sido procesada correctamente',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Card con el comprobante de la transacción
  Widget _buildComprobanteCard(dynamic transaccion, RetiroController controller) {
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
          Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.blue[700], size: 30),
              const SizedBox(width: 15),
              Text(
                'Comprobante de Transacción',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.grey[300]),
          const SizedBox(height: 15),

          _buildComprobanteRow('Fecha', _formatearFecha(transaccion.fechaHora)),
          _buildComprobanteRow('Hora', _formatearHora(transaccion.fechaHora)),
          _buildComprobanteRow('Tipo', _obtenerNombreTipoRetiro(transaccion.tipoRetiro)),
          _buildComprobanteRow('Identificación', _formatearIdentificacion(transaccion)),
          _buildComprobanteRow('Monto', '\$${_formatearMonto(transaccion.monto)}'),
          if (transaccion.referencia != null)
            _buildComprobanteRow('Referencia', transaccion.referencia!),

          const SizedBox(height: 15),
          Divider(color: Colors.grey[300]),
          const SizedBox(height: 15),

          Center(
            child: Column(
              children: [
                Text(
                  'UNIVERSIDAD POPULAR DEL CÉSAR',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Sistema de Cajero Automático',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card que muestra los billetes entregados
  Widget _buildBilletesCard(dynamic transaccion) {
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
          Row(
            children: [
              Icon(Icons.money, color: Colors.green[700], size: 30),
              const SizedBox(width: 15),
              Text(
                'Billetes Entregados',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          ...transaccion.billetesEntregados.entries.map((entry) {
            final denominacion = entry.key;
            final cantidad = entry.value;

            if (cantidad > 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.money, color: Colors.green[700], size: 20),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Billetes de \$${_formatearMonto(denominacion.toDouble())}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            'Cantidad: $cantidad',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${_formatearMonto((denominacion * cantidad).toDouble())}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          }).toList(),

          const SizedBox(height: 15),
          Divider(color: Colors.grey[300]),
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total de billetes:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                '${transaccion.billetesEntregados.values.fold(0, (sum, qty) => sum + qty)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Card con predicción de retiros restantes
  Widget _buildRetirosRestantesCard(RetiroController controller) {
    final retirosRestantes = controller.calcularRetirosRestantes(controller.monto);

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue[300]!, width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: Colors.blue[700], size: 30),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  'Predicción de Retiros',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Retiros restantes de \$${_formatearMonto(controller.monto)}:',
                style: TextStyle(fontSize: 16, color: Colors.blue[700]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$retirosRestantes',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Botones finales
  Widget _buildBotonesFinales(BuildContext context, RetiroController controller) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => _nuevoRetiro(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add),
                const SizedBox(width: 10),
                Text(
                  'Realizar Otro Retiro',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 15),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => _finalizarSesion(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.exit_to_app),
                const SizedBox(width: 10),
                Text(
                  'Finalizar Sesión',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Widget para mostrar error
  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
          const SizedBox(height: 20),
          Text(
            'Error al cargar el resultado',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red[700]),
          ),
          const SizedBox(height: 10),
          Text(
            'No se pudo obtener la información de la transacción',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Fila de información del comprobante
  Widget _buildComprobanteRow(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$etiqueta:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: Text(valor, style: TextStyle(color: Colors.grey[800])),
          ),
        ],
      ),
    );
  }

  /// Formatea la identificación según el tipo de retiro
  String _formatearIdentificacion(dynamic transaccion) {
    switch (transaccion.tipoRetiro.toString()) {
      case 'TipoRetiro.nequi':
        return '0${transaccion.numeroIdentificacion}'; // Agrega 0 al inicio
      default:
        return transaccion.numeroIdentificacion;
    }
  }

  /// Formatea fecha
  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }

  /// Formatea hora
  String _formatearHora(DateTime fecha) {
    final hora = fecha.hour > 12 ? fecha.hour - 12 : (fecha.hour == 0 ? 12 : fecha.hour);
    final periodo = fecha.hour >= 12 ? 'PM' : 'AM';
    return '${hora.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')} $periodo';
  }

  /// Formatea monto
  String _formatearMonto(double monto) {
    return monto
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},');
  }

  /// Navega para nuevo retiro
  void _nuevoRetiro(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  /// Finaliza la sesión
  void _finalizarSesion(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  /// Obtiene el nombre descriptivo del tipo de retiro
  String _obtenerNombreTipoRetiro(TipoRetiro tipo) {
    switch (tipo) {
      case TipoRetiro.nequi:
        return 'NEQUI - Retiro con Celular';
      case TipoRetiro.ahorroMano:
        return 'Ahorro a la Mano';
      case TipoRetiro.cuentaAhorro:
        return 'Cuenta de Ahorros';
    }
  }
}
