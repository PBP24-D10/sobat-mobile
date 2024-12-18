import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class productTile extends StatefulWidget {
  int price;
  String name;
  String imageUrl;
  void Function()? onPressed;

  productTile(
      {super.key,
      required this.name,
      required this.price,
      required this.imageUrl,
      required this.onPressed});

  @override
  State<productTile> createState() => _productTileState();
}

class _productTileState extends State<productTile> {
  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.currency(
      locale: 'id_ID', // Locale Indonesia
      symbol: 'Rp ', // Simbol mata uang
      decimalDigits: 0, // Tanpa desimal
    ).format(widget.price);
    return GestureDetector(
      onTap: () {},
      child: AspectRatio(
        aspectRatio: 0.75,
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.grey[350],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            widget.imageUrl, // Use the full URL here
                            height: 120,

                            // Adjusting to the screen width minus paddin

                            errorBuilder: (context, error, stackTrace) {
                              return Text('Unable to load image',
                                  textAlign: TextAlign.center);
                            },
                          ),
                        ),
                      ),
                    ),
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(formattedPrice),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.trash),
                            onPressed: widget.onPressed,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
