import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart' hide CarouselController;
import '../services/product_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  List<dynamic> _products = [];
  bool _isLoading = true;
  int _currentBannerIndex = 0;
  final List<String> _bannerImages = [
    'https://via.placeholder.com/800x400?text=Banner+1',
    'https://via.placeholder.com/800x400?text=Banner+2',
    'https://via.placeholder.com/800x400?text=Banner+3',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _productService.getProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace 3D'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Carrusel de banners
                _buildBannerCarousel(),
                const SizedBox(height: 20),
                
                // Lista de productos
                Expanded(
                  child: _products.isEmpty
                      ? const Center(child: Text('No hay productos disponibles'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return _buildProductCard(product);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildBannerCarousel() {
    return Column(
      children: [
        CarouselSlider(
          items: _bannerImages.map((imageUrl) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16/9,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() => _currentBannerIndex = index);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _bannerImages.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentBannerIndex == entry.key
                    ? Colors.blue
                    : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagen del producto
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product['images']?.isNotEmpty == true 
                    ? product['images'][0]
                    : 'https://via.placeholder.com/100?text=No+Image',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 16),
            
            // Detalles del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? 'Producto sin nombre',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product['price'] ?? '0.00'}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['category'] ?? 'Sin categoría',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            
            // Botón de acción
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}