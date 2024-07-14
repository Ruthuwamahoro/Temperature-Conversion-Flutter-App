import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp(
    home: NinjaCard(),
  ));
}

class NinjaCard extends StatefulWidget {
  const NinjaCard({super.key});

  @override
  State<NinjaCard> createState() => _NinjaCardState();
}

class _NinjaCardState extends State<NinjaCard> {
  String _selectedUnit = '°C - °F';
  final List<String> _units = ['°C - °F', '°F - °C'];
  final TextEditingController _controller = TextEditingController();
  String _convertedValue = '';
  List<String> _history = [];

  void _convertTemperature() {
    double input = double.tryParse(_controller.text) ?? 0.0;
    double result;

    if (_selectedUnit == '°C - °F') {
      result = input * 9 / 5 + 32;
      setState(() {
        _convertedValue = '$input °C = ${result.toStringAsFixed(2)} °F';
        _history.add(_convertedValue);
      });
    } else if (_selectedUnit == '°F - °C') {
      result = (input - 32) * 5 / 9;
      setState(() {
        _convertedValue = '$input °F = ${result.toStringAsFixed(2)} °C';
        _history.add(_convertedValue);
      });
    }
  }

  void _goToHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryPage(history: _history),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Temperature Converter',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 40.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: _selectedUnit == '°C - °F' ? "°C" : "°F",
                  labelText: "Enter Temperature in (°C or °F)",
                  suffixIcon: DropdownButton<String>(
                    value: _selectedUnit,
                    items: _units.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedUnit = value!;
                      });
                    },
                    underline: Container(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _convertTemperature,
                child: Text('Convert', style: TextStyle(),),
              ),
              SizedBox(height: 20),
              Text(
                _convertedValue,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 40.0,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          ],
          onTap: (index) {
            if (index == 1) {
              _goToHistory(context);
            }
          },
        ),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  final List<String> history;

  HistoryPage({required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversion History', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.grey[850],
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(history[index]),
          );
        },
      ),
    );
  }
}
