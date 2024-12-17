import 'package:flutter/material.dart';

class DigitalCarbonFootprintScreen extends StatefulWidget {
  @override
  _DigitalCarbonFootprintScreenState createState() => _DigitalCarbonFootprintScreenState();
}

class _DigitalCarbonFootprintScreenState extends State<DigitalCarbonFootprintScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = [];
  final List<String> _apps = ["YouTube", "Netflix", "Social Media", "Gaming"];
  final Map<String, double> _usageHours = {}; // Stores user input for each app
  double _totalEmissionDaily = 0.0;

  // Function to calculate carbon emissions
  double calculateCarbonEmission(double powerUsage, double hoursUsed) {
    const double emissionFactor = 0.5; // kgCO2/kWh
    return powerUsage * hoursUsed * emissionFactor;
  }

  void _calculateEmissions() {
    double totalEmission = 0.0;

    for (int i = 0; i < _apps.length; i++) {
      final appName = _apps[i];
      final usage = double.tryParse(_controllers[i].text) ?? 0.0;
      _usageHours[appName] = usage;
      totalEmission += calculateCarbonEmission(0.1, usage); // Assuming 0.1 kWh per hour
    }

    setState(() {
      _totalEmissionDaily = totalEmission;
    });
  }

  @override
  void initState() {
    super.initState();
    for (var app in _apps) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text('Digital Carbon Footprint'),
  backgroundColor: const Color.fromARGB(255, 118, 121, 118), // Keep the green background
  foregroundColor: const Color.fromARGB(255, 16, 16, 16), // Make the title white for contrast
  elevation: 4, // Add some elevation for shadow effect
),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.black.withOpacity(0.6), // Dark background for card
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Track your daily app usage and discover how it impacts your carbon footprint. Small changes can make a big difference!",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white), // White text
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Enter your daily usage (hours):",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white), // White text
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: _apps.asMap().entries.map((entry) {
                  final index = entry.key;
                  final app = entry.value;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.black.withOpacity(0.5), // Dark background for input cards
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _controllers[index],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "$app usage (hours)",
                          labelStyle: TextStyle(color: Colors.white), // White label text
                          prefixIcon: Icon(Icons.access_time_rounded, color: Colors.white), // White icon
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: TextStyle(color: Colors.white), // White text for input
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter usage for $app';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Black background for button
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _calculateEmissions();
                  }
                },
                child: Text('Calculate Emissions', style: TextStyle(fontSize: 16, color: Colors.white)), // White text on button
              ),
            ),
            if (_totalEmissionDaily > 0) ...[
              SizedBox(height: 30),
              Text(
                "Your Results:",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white), // White text
              ),
              SizedBox(height: 10),
              Card(
                color: Colors.black.withOpacity(0.5), // Dark background for result card
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Daily Carbon Emission: ${_totalEmissionDaily.toStringAsFixed(2)} kgCO₂",
                        style: TextStyle(fontSize: 16, color: Colors.white), // White text
                      ),
                      Text(
                        "Weekly Carbon Emission: ${(7 * _totalEmissionDaily).toStringAsFixed(2)} kgCO₂",
                        style: TextStyle(fontSize: 16, color: Colors.white), // White text
                      ),
                      Text(
                        "Monthly Carbon Emission: ${(30 * _totalEmissionDaily).toStringAsFixed(2)} kgCO₂",
                        style: TextStyle(fontSize: 16, color: Colors.white), // White text
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Reduction Ideas:",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white), // White text
              ),
              SizedBox(height: 10),
              Card(
                color: Colors.black.withOpacity(0.4), // Dark background for suggestions card
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "- Limit video streaming quality.\n"
                    "- Use dark mode to save energy.\n"
                    "- Schedule app usage to reduce screen time.\n"
                    "- Avoid leaving apps running in the background.",
                    style: TextStyle(fontSize: 16, color: Colors.white), // White text
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      backgroundColor: Colors.black, // Black background for the entire screen
    );
  }
}
