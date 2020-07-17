import 'package:flutter/material.dart';
import 'package:gustolact/src/models/product_model.dart';
import 'package:gustolact/src/providers/search_provider.dart';
import 'package:provider/provider.dart';

class SugerencesList extends StatelessWidget {
  final List<ProductModel> items;

  const SugerencesList({@required this.items});
  @override
  Widget build(BuildContext context) {

    SearchProvider searchProvider = Provider.of<SearchProvider>(context);

    return ListView(
      children: items.map((item) {
        item.uniqueId = '${item.codi}-search';
        return ListTile(
          leading: Hero(
            tag: item.uniqueId,
            child: FadeInImage(
              placeholder: AssetImage('assets/gif/loading.gif'),
              image: NetworkImage(item.getImage()),
              width: 50.0,
              fit: BoxFit.contain,
            ),
          ),
          title: Text(item.name),
          subtitle: Text(item.brand),
          onTap: () {
//                  searchProvider.query = query;
            searchProvider.sugerences = items;
            Navigator.pushNamed(context, 'product_detail',
                arguments: item);
          },
        );
      }).toList(),
    );
  }
}