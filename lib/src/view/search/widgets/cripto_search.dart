import 'package:cripto/src/models/cripto.dart';
import 'package:flutter/material.dart';

import '../../cripto_details/cripto_details_view.dart';

class CriptoSearch extends StatefulWidget {
  final List<Cripto> allCoins; 

  const CriptoSearch({super.key, required this.allCoins});

  @override
  State<CriptoSearch> createState() => _CriptoSearchState();
}

class _CriptoSearchState extends State<CriptoSearch> {
  List<Cripto> _filteredCoins = [];
  bool _noResults = false;

  void _filterCoins(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredCoins = [];
        _noResults = false;
      });
      return;
    }

    final filtered = widget.allCoins.where((cripto) =>
        cripto.name.toLowerCase().contains(query.toLowerCase())).toList();

    setState(() {
      _filteredCoins = filtered;
      _noResults = filtered.isEmpty; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: _filterCoins,
          decoration: InputDecoration(
            labelText: 'Buscar criptomoeda',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        if (_noResults)
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Nenhuma moeda encontrada com esse nome.',
              style: TextStyle(color: Colors.red),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredCoins.length,
            itemBuilder: (context, index) {
              final cripto = _filteredCoins[index];
              return ListTile(
                title: Text(cripto.name),
                subtitle: Text(cripto.symbol.toUpperCase()),
                leading: Image.network(cripto.image, width: 30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(criptoId: cripto.id),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}