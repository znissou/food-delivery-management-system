import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manager_app/services/meal_service.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({Key? key}) : super(key: key);

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final MealService _mealService = MealService();
  final ImagePicker _picker = ImagePicker();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  
  File? _image;
  int? _selectedCategory;
  bool _isLoading = false;

  final Map<int, String> _categories = {
    4: 'sandwitch',
    5: 'pizza',
    1: 'soupe',
    2: 'salade',
    3: 'dessert',
  };

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty || _selectedCategory == null) {
       // Simple validation
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez remplir tous les champs')));
       return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _mealService.createMeal(
        _nameController.text,
        _ingredientsController.text,
        double.parse(_priceController.text),
        _selectedCategory!,
        _image?.path,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un repas'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "Ajouter un repas au menu",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: "Nom du repas", hintText: "ex:Tacos"),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: _ingredientsController,
              decoration: const InputDecoration(
                  labelText: "Ingredients", hintText: ""),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                  labelText: "Prix en DA", hintText: "ex:200"),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<int>(
              hint: const Text("categorie"),
              dropdownColor: Colors.grey,
              icon: const Icon(Icons.arrow_drop_down),
              value: _selectedCategory,
              onChanged: (int? value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              items: _categories.entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            _image == null
                ? IconButton(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.add_photo_alternate, size: 40, color: Colors.blue),
                  )
                : Container(
                    margin: const EdgeInsets.all(10),
                    height: 150,
                    child: Image.file(_image!),
                  ),
            const SizedBox(height: 30),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              FloatingActionButton.extended(
                onPressed: _submit,
                label: const Text("Ajouter"),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
