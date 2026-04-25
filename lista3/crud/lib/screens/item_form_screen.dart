import 'package:flutter/material.dart';

import '../models/grocery_item.dart';
import '../services/api_service.dart';

class ItemFormScreen extends StatefulWidget {
  final GroceryItem? item;

  const ItemFormScreen({super.key, this.item});

  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _unitCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  bool _isSaving = false;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final item = widget.item!;
      _nameCtrl.text = item.name;
      _quantityCtrl.text = item.quantity.toString();
      _unitCtrl.text = item.unit;
      _categoryCtrl.text = item.category;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _quantityCtrl.dispose();
    _unitCtrl.dispose();
    _categoryCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final newItem = GroceryItem(
        id: widget.item?.id ?? 0,
        name: _nameCtrl.text.trim(),
        quantity: double.parse(_quantityCtrl.text.trim()),
        unit: _unitCtrl.text.trim(),
        category: _categoryCtrl.text.trim(),
        bought: widget.item?.bought ?? false,
      );

      if (_isEditing) {
        await ApiService.updateItem(newItem);
      } else {
        await ApiService.createItem(newItem);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Item' : 'Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantityCtrl,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Quantity is required';
                  final n = double.tryParse(v.trim());
                  if (n == null || n <= 0) return 'Enter a valid number greater than 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _unitCtrl,
                decoration: const InputDecoration(
                  labelText: 'Unit',
                  hintText: 'e.g. kg, units, liters, packs',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Unit is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryCtrl,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  hintText: 'e.g. Fruits, Dairy, Bakery',
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Category is required' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _submit,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
