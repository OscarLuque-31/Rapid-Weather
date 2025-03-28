import 'package:rapid_weather/models/condition.dart';

/// Clase Current que representa el clima en estos momentos
class Current {
  final String lastUpdated;
  final double tempC;
  final int isDay;
  final Condition condition;
  final double windKph;
  final double precipMm;
  final int humidity;
  final int cloud;
  final double feelslikeC;
  final double windchillC;
  final double heatindexC;
  final double dewpointC;
  final double visKm;
  final double uv;
  final double gustKph;

  Current({
    required this.lastUpdated,
    required this.tempC,
    required this.isDay,
    required this.condition,
    required this.windKph,
    required this.precipMm,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.windchillC,
    required this.heatindexC,
    required this.dewpointC,
    required this.visKm,
    required this.uv,
    required this.gustKph,
  });

  // Método para transformar el JSON a un objeto Current y lo retorna
  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      lastUpdated: json['last_updated'] ?? '',
      tempC: json['temp_c']?.toDouble() ?? 0.0,
      isDay: json['is_day'] ?? 0,
      condition: Condition.fromJson(json['condition'] ?? {}),
      windKph: json['wind_kph']?.toDouble() ?? 0.0,
      precipMm: json['precip_mm']?.toDouble() ?? 0.0,
      humidity: json['humidity'] ?? 0,
      cloud: json['cloud'] ?? 0,
      feelslikeC: json['feelslike_c']?.toDouble() ?? 0.0,
      windchillC: json['windchill_c']?.toDouble() ?? 0.0,
      heatindexC: json['heatindex_c']?.toDouble() ?? 0.0,
      dewpointC: json['dewpoint_c']?.toDouble() ?? 0.0,
      visKm: json['vis_km']?.toDouble() ?? 0.0,
      uv: json['uv']?.toDouble() ?? 0.0,
      gustKph: json['gust_kph']?.toDouble() ?? 0.0,
    );
  }


  // Método para devolver un objeto vacío en caso de error
  factory Current.empty() {
    return Current(
      lastUpdated: '',
      tempC: 0.0,
      isDay: 0,
      condition: Condition.empty(),
      windKph: 0.0,
      precipMm: 0.0,
      humidity: 0,
      cloud: 0,
      feelslikeC: 0.0,
      windchillC: 0.0,
      heatindexC: 0.0,
      dewpointC: 0.0,
      visKm: 0.0,
      uv: 0.0,
      gustKph: 0.0,
    );
  }

  
}