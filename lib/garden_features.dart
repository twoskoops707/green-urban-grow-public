// ----- GardenPlanner and ShoppingList Combined -----
import 'package:flutter/material.dart';

// -------------------- GardenPlanner --------------------
class GardenPlanner extends StatefulWidget {
  @override
  _GardenPlannerState createState() => _GardenPlannerState();
}

class _GardenPlannerState extends State<GardenPlanner> {
  final List<Map<String, dynamic>> _gardenPlants = [];
  final TextEditingController _plantController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  DateTime? _selectedDate;

  void _addPlant() {
    final name = _plantController.text.trim();
    final qty = int.tryParse(_quantityController.text.trim()) ?? 1;
    if (name.isEmpty) return;
    setState(() {
      _gardenPlants.add({
        'name': name,
        'quantity': qty,
        'date': _selectedDate ?? DateTime.now(),
      });
    });
    _plantController.clear();
    _quantityController.clear();
    _selectedDate = null;
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Garden Planner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _plantController,
              decoration: InputDecoration(labelText: 'Plant Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(_selectedDate != null
                      ? 'Planting: ${_selectedDate!.toLocal()}'.split(' ')[0]
                      : 'Select Planting Date'),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _pickDate(context),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _addPlant,
              child: Text('Add to Garden'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _gardenPlants.isEmpty
                  ? Center(child: Text('No plants added yet.'))
                  : ListView.builder(
                      itemCount: _gardenPlants.length,
                      itemBuilder: (context, index) {
                        final plant = _gardenPlants[index];
                        return ListTile(
                          title: Text('${plant['name']} (x${plant['quantity']})'),
                          subtitle: Text(
                              'Planting Date: ${plant['date'].toLocal()}'.split(' ')[0]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- ShoppingList --------------------
class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final List<Map<String, dynamic>> _items = [];
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _addItem() {
    final name = _itemController.text.trim();
    final qty = int.tryParse(_quantityController.text.trim()) ?? 1;
    if (name.isEmpty) return;
    setState(() {
      _items.add({'name': name, 'quantity': qty});
    });
    _itemController.clear();
    _quantityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shopping List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _itemController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Add to Shopping List'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _items.isEmpty
                  ? Center(child: Text('No items added yet.'))
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return ListTile(
                          title: Text('${item['name']} (x${item['quantity']})'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
