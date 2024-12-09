import 'package:flutter/material.dart';

class productTile extends StatefulWidget {
  int price;
  String name;

  productTile({super.key, required this.name, required this.price});

  @override
  State<productTile> createState() => _productTileState();
}

class _productTileState extends State<productTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 200,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                width: 180,
                height: 200,
              ),
              Text(widget.name),
              Text(widget.price.toString()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Icon(Icons.add)],
              )
            ],
          ),
        ),
      ),
    );
  }
}
