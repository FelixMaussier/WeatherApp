import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../services/weather_service.dart';
import '../models/weather.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _controller = TextEditingController();
  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchWeather('Stockholm');
  }

  Future<void> _fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final weather = await _weatherService.fetchWeather(city);
    setState(() {
      _weather = weather;
      _isLoading = false;
      if (weather == null) {
        _error = 'Kunde inte hämta väderdata.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Gradientbakgrund
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1B0643),
                  Color(0xFF3D155F),
                  Color(0xFF602080),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Sökfält
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: GoogleFonts.orbitron(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Skriv stad... ',
                            hintStyle: GoogleFonts.orbitron(
                              color: Colors.white54,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.08),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 0,
                            ),
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _fetchWeather(value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            _fetchWeather(_controller.text);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _error!,
                        style: GoogleFonts.orbitron(color: Colors.redAccent),
                      ),
                    ),
                  if (_weather != null && !_isLoading)
                    Column(
                      children: [
                        Text(
                          _weather!.city,
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${_weather!.temperature.round()}°',
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 80,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              _weather!.iconUrl,
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _weather!.description,
                              style: GoogleFonts.orbitron(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _WeatherInfo(
                              icon: Icons.air,
                              label: 'Vind',
                              value: '${_weather!.windSpeed} km/h',
                            ),
                            _WeatherInfo(
                              icon: Icons.opacity,
                              label: 'Fukt',
                              value: '${_weather!.humidity}%',
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          // Wave animation längst ner
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [Color(0xFF1B0643), Color(0xFF602080)],
                    [Color(0xFF602080), Color(0xFFB388FF)],
                    [Color(0xFF3D155F), Color(0xFFB388FF)],
                  ],
                  durations: [35000, 19440, 10800],
                  heightPercentages: [0.20, 0.23, 0.26],
                  blur: MaskFilter.blur(BlurStyle.solid, 5),
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                waveAmplitude: 18,
                backgroundColor: Colors.transparent,
                size: const Size(double.infinity, double.infinity),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _WeatherInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
