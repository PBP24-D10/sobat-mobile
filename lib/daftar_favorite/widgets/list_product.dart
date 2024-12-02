import 'package:flutter/material.dart';

class productTile extends StatelessWidget {
  const productTile({super.key});

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
              Text("Shoes"),
              Text("Price"),
              Text("Rating"),
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
