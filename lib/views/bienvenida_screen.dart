import 'package:flutter/material.dart';
import 'package:rapid_weather/routes/routes.dart';
import 'package:rapid_weather/services/bbdd_service.dart';
import 'package:rapid_weather/utils/app_colors.dart';

/// Pantalla de bienvenida que verifica si el usuario está registrado y
/// lo redirige a la pantalla principal o le permite registrarse.
class BienvenidaScreen extends StatefulWidget {
  const BienvenidaScreen({super.key});

  @override
  State<BienvenidaScreen> createState() => _BienvenidaScreenState();
}

class _BienvenidaScreenState extends State<BienvenidaScreen> {
  bool isFirstTime = true; // Estado para almacenar si la primera vez

  @override
  void initState() {
    super.initState();
    _checkFirstTimeStatus(); // Verifica el estado de registro al iniciar la pantalla
  }

  /// Verifica si el usuario es la primera vez que entra en la aplicación
  /// Si no es así, lo redirige automáticamente a la pantalla principal.
  Future<void> _checkFirstTimeStatus() async {
    bool isFirstTime = await DBService().isFirstTime();
    setState(() {
      this.isFirstTime = isFirstTime;
    });

    if (!isFirstTime) {
      if (mounted) {
        // Si es la primera vez, redirige directamente a la pantalla principal y limpia el historial de navegación
        Navigator.pushReplacementNamed(context, AppRoutes.principal);
      }
    }
  }

   /// Función para manejar el cambio de estado de la primera vez y la navegación.
  Future<void> _handleStartButtonPress() async {
    await DBService().setFirstTimeFalse(); // Cambia el estado a no primera vez
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.principal); // Navega a la pantalla principal
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Logo centrado en la pantalla
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/logo_rapid_weather.png',
                width: 300,
              ),
            ),
          ),

          // Contenedor inferior con mensaje y botón de inicio
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            width: 360,
            height: 180,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: AppColors.azulGrisaceoWeather,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mensaje de bienvenida
                const Text(
                  "Conecta con tu clima, sin complicaciones",
                  style: TextStyle(
                    fontFamily: 'ReadexPro',
                    fontWeight: FontWeight.w700,
                    color: AppColors.azulClaroWeather,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35.0),

                // Botón de "Empezar"
                ElevatedButton(
                  onPressed: _handleStartButtonPress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blancoWeather,
                    minimumSize: const Size(320, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "Empezar",
                    style: TextStyle(
                      fontFamily: 'ReadexPro',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.azulGrisaceoWeather,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
