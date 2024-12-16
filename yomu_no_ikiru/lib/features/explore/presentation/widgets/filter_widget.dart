import 'package:flutter/material.dart';

abstract interface class Filter extends StatelessWidget {
  const Filter({super.key});

  Widget header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class MangaWorldFilter extends Filter {
  const MangaWorldFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
      ),
      body: Column(
        children: [
          header(context),
          const SizedBox(height: 8),
          const Text('MangaWorld Filter'),
        ],
      ),
    );
  }
  
}
