import 'package:flutter/material.dart';
import '../model/product.dart';
import '../repository/product_repository.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductRepository _productRepository = ProductRepository();

  // Controllers for adding products
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();

  late Future<List<Product>> _productList;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Load all products from the database
  void _loadProducts() {
    _productList = _productRepository.getAllProducts();
    setState(() {}); // Refresh the UI to display the loaded products
  }

  // Add a new product
  // void _addProduct() async {
  //   final product = Product(
  //     name: _productNameController.text,
  //     price: double.tryParse(_productPriceController.text) ?? 0.0, description: 'bcsb',
  //   );
  //
  //   await _productRepository.insertProduct(product);
  //
  //   // Clear the text fields
  //   _productNameController.clear();
  //   _productPriceController.clear();
  //
  //   // Reload products after adding
  //   _loadProducts();
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product added successfully")));
  // }

  // Delete product
  Future<void> _deleteProduct(int productId) async {
    bool confirmDelete = await _showDeleteDialog(context);
    if (confirmDelete) {
      await _productRepository.deleteProduct(productId);
      _loadProducts();  // Reload products after deletion
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product deleted successfully")));
    }
  }

  // Function to show delete confirmation dialog
  Future<bool> _showDeleteDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product Settings",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // New product input form
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTextField('Product Name', _productNameController),
                      const SizedBox(height: 10),
                      _buildTextField('Product Price', _productPriceController),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: (){},
                        child: const Text("Add Product"),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Product list display
              const Text(
                "Existing Products",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Displaying product list
              Expanded(
                child: FutureBuilder<List<Product>>(
                  future: _productList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final products = snapshot.data!;
                      if (products.isEmpty) {
                        return Center(child: Text("No products available"));
                      }
                      return ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                            child: ListTile(
                              title: Text(product.name),
                              subtitle: Text('Price: \$${product.brand}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteProduct(product.id!),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text("No products available"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable method for building text fields
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }
}
