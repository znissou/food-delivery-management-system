import 'package:flutter/material.dart';
import 'package:manager_app/models/order_model.dart';
import 'package:manager_app/services/order_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderService _orderService = OrderService();
  late Future<List<Order>> _ordersFuture;

  final List<Color> _statusColors = [
    Colors.red,
    Colors.orange,
    Colors.blue,
    Colors.green
  ];

  @override
  void initState() {
    super.initState();
    _refreshOrders();
  }

  void _refreshOrders() {
    setState(() {
      _ordersFuture = _orderService.getOrders();
    });
  }

  void _goToOrderDetails(Order order) {
    Navigator.of(context).pushNamed(
      '/order',
      arguments: order,
    ).then((_) {
      _refreshOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Order>>(
        future: _ordersFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
             return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune commande"));
          } else {
            return ListView.separated(
              itemBuilder: (_, index) {
                final order = snapshot.data![index];
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: ListTile(
                        onTap: () => _goToOrderDetails(order),
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  const Text(
                                    "Commande ",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text("${order.id}"),
                                ],
                              ),
                            ),
                            const SizedBox(width: 30),
                            SizedBox(
                              width: 160,
                              child: Text(
                                order.address,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black45),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            const Text(
                              "Commande",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.transparent),
                            ),
                            Text(
                              "${order.id}",
                              style: const TextStyle(color: Colors.transparent),
                            ),
                            const SizedBox(width: 45),
                            Text(
                              "0${order.phone}",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black45),
                            )
                          ],
                        ),
                        trailing: CircleAvatar(
                          backgroundColor:
                              _statusColors[order.status % _statusColors.length],
                          radius: 15,
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (_, __) => const Divider(height: 10, thickness: 10, color: Colors.black12),
              itemCount: snapshot.data!.length,
            );
          }
        },
      ),
    );
  }
}
