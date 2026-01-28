import 'package:flutter/material.dart';
import 'package:manager_app/models/order_model.dart';
import 'package:manager_app/services/order_service.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final OrderService _orderService = OrderService();
  late Order _order;
  late Future<List<dynamic>> _detailsFuture;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is Order) {
        _order = args;
        _detailsFuture = _orderService.getOrderDetails(_order.id);
        _initialized = true;
      }
    }
  }

  Future<void> _updateState(int newState) async {
    final success = await _orderService.updateOrderState(_order.id, newState);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('etat updated'),
      ));
      Navigator.pop(context); // Go back after update
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('erreur il existe un repas non disponible daans la commande'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _detailsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
             return Center(child: Text("Erreur: ${snapshot.error}"));
          } else {
            final items = snapshot.data ?? [];
            return Container(
              margin: const EdgeInsets.only(top: 60),
              child: ListView.builder(
                itemCount: items.length + 2,
                itemBuilder: (_, index) {
                  if (index < items.length) {
                    final item = items[index];
                    return Container(
                      margin: const EdgeInsets.fromLTRB(90, 10, 20, 10),
                      child: Row(
                        children: [
                          Text(
                            "${item['nom']} x ${item['quantite']}",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 50),
                          Text(
                            " ${item['prix'] * item['quantite']} DA",
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    );
                  } else if (index == items.length) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(90, 10, 20, 10),
                       child: Row(
                        children: [
                          const Text(
                            "Prix totale",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 50),
                          Text(
                            "${_order.totalPrice} DA",
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ); 
                  } else {
                     // Buttons area
                     return Column(
                       children: [
                         const SizedBox(height: 50),
                         if (_order.status == 1)
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               ElevatedButton(
                                 onPressed: () => _updateState(2),
                                 style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                 child: Row(
                                   children: const [
                                     Icon(Icons.check),
                                     Text('Accepter'),
                                   ],
                                 ),
                               ),
                               const SizedBox(width: 30),
                               ElevatedButton(
                                 onPressed: () => _updateState(0),
                                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                 child: Row(
                                   children: const [
                                     Icon(Icons.clear),
                                     Text('Refuser'),
                                   ],
                                 ),
                               ),
                             ],
                           )
                         else if (_order.status == 2)
                           Container(
                              margin: const EdgeInsets.only(right: 60),
                              child: ElevatedButton(
                                onPressed: () => _updateState(3),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                                child: const Text('preparé'),
                              ),
                           )
                         else if (_order.status == 0)
                           Container(
                             margin: const EdgeInsets.only(right: 60),
                             child: const Text('refusé', style: TextStyle(color: Colors.red)),
                           )
                         else
                           Container(
                             margin: const EdgeInsets.only(right: 60),
                             child: const Text('preparé'),
                           ) // status 3 or others
                       ],
                     );
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}
