import 'package:flutter/material.dart';
import 'package:flutter_application/pages/Consts.dart';
import 'package:weather/weather.dart';

class Cuaca extends StatefulWidget {
  const Cuaca({Key? key}) : super(key: key);

  @override
  State<Cuaca> createState() => _CuacaState();
}

class _CuacaState extends State<Cuaca> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  late String _selectedCity; // Kota default: Bandung
  late TextEditingController _cityController;

  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _selectedCity = 'Bandung';
    _cityController = TextEditingController(text: _selectedCity);
    fetchWeather();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> fetchWeather() async {
    try {
      Weather? weather = await _wf.currentWeatherByCityName(_selectedCity);
      if (mounted) {
        setState(() {
          _weather = weather;
        });
      }
    } on OpenWeatherAPIException catch (e) {
      // Tangani kesalahan API OpenWeather di sini
      if (mounted) {
        setState(() {
          _weather = null;
          // Tampilkan pesan jika lokasi tidak ditemukan
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Location Not Found'),
                content: Text('The city you entered was not found.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Metode untuk mendapatkan ikon cuaca berdasarkan kondisi cuaca
  IconData getWeatherIcon(String? weatherCondition) {
    switch (weatherCondition?.toLowerCase() ?? '') {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.beach_access; // Ubah dengan ikon hujan yang sesuai
      default:
        return Icons.help_outline;
    }
  }

  // Metode untuk memperbarui cuaca berdasarkan kota yang dipilih
  void updateWeather() {
    setState(() {
      _selectedCity = _cityController.text;
    });
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cityController,
              autofocus: false, // Menonaktifkan fokus visual pada TextField
              decoration: InputDecoration(
                labelText: 'City',
                hintText: 'Enter city name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: updateWeather,
              child: Text('Get Weather'),
            ),
            SizedBox(height: 20),
            _weather != null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Current Weather in ${_weather!.areaName}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              getWeatherIcon(_weather!.weatherMain),
                              size: 50,
                              color: Colors.black, // Warna ikon (hitam)
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Temperature:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black, // Warna teks (hitam)
                                  ),
                                ),
                                Text(
                                  '${_weather!.temperature?.celsius?.toStringAsFixed(0) ?? "-"}°C',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Warna teks (hitam)
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Condition: ${_weather!.weatherMain}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black, // Warna teks (hitam)
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
