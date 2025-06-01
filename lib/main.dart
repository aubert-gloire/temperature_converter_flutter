import 'package:flutter/material.dart';

void main() {
  runApp(const TempConverterApp());
}
class TempConverterApp extends StatelessWidget {
  const TempConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: Colors.purple,
      ),
      home: const TempConverterHome(),
    );
  }
}

class TempConverterHome extends StatefulWidget {
  const TempConverterHome({super.key});

  @override
  State<TempConverterHome> createState() => _TempConverterHomeState();
}

class _TempConverterHomeState extends State<TempConverterHome> {
  final TextEditingController _controller = TextEditingController();
  String _conversionType = 'F to C';
  double? _convertedValue;
  final List<String> _history = [];

  void _convert() {
    final input = double.tryParse(_controller.text);
    if (input == null) return;

    double result;
    String historyEntry;

    if (_conversionType == 'F to C') {
      result = (input - 32) * 5 / 9;
      historyEntry = 'F to C: $input ➔ ${result.toStringAsFixed(2)}';
    } else {
      result = (input * 9 / 5) + 32;
      historyEntry = 'C to F: $input ➔ ${result.toStringAsFixed(2)}';
    }

    setState(() {
      _convertedValue = result;
      _history.insert(0, historyEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isPortrait ? _buildPortraitLayout() : _buildLandscapeLayout(isSmallScreen),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildConversionSection(),
        const SizedBox(height: 20),
        _buildInputSection(),
        const SizedBox(height: 20),
        _buildConvertButton(),
        const SizedBox(height: 20),
        _buildHistorySection(),
      ],
    );
  }

  Widget _buildLandscapeLayout(bool isSmallScreen) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildConversionSection(),
                SizedBox(height: isSmallScreen ? 12 : 20),
                _buildInputSection(),
                SizedBox(height: isSmallScreen ? 12 : 20),
                _buildConvertButton(),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: _buildHistorySection(),
        ),
      ],
    );
  }

  Widget _buildConversionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Conversion:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.purple,
          ),
        ),
        Row(
          children: [
            Radio(
              value: 'F to C',
              groupValue: _conversionType,
              activeColor: Colors.purple,
              onChanged: (value) => setState(() => _conversionType = value!),
            ),
            const Text('Fahrenheit to Celsius'),
          ],
        ),
        Row(
          children: [
            Radio(
              value: 'C to F',
              groupValue: _conversionType,
              activeColor: Colors.purple,
              onChanged: (value) => setState(() => _conversionType = value!),
            ),
            const Text('Celsius to Fahrenheit'),
          ],
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter temperature',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple, width: 2),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '=',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              border: Border.all(color: Colors.purple.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _convertedValue?.toStringAsFixed(2) ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.purple,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConvertButton() {
    return ElevatedButton(
      onPressed: _convert,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      child: const Text('CONVERT'),
    );
  }

  Widget _buildHistorySection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'History:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _history.isEmpty
                  ? const Center(
                      child: Text(
                        'No conversions yet',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(_history[index]),
                        leading: const Icon(
                          Icons.thermostat,
                          color: Colors.purple,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}