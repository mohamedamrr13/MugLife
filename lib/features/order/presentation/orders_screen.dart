import 'package:drinks_app/core/di/service_locator.dart';
import 'package:drinks_app/features/order/data/models/order_model.dart';
import 'package:drinks_app/features/order/presentation/cubit/order_cubit.dart';
import 'package:drinks_app/features/order/presentation/widgets/order_card.dart';
import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      context.read<OrderCubit>().getUserOrders(userId: currentUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<OrderCubit>()..getUserOrders(userId: currentUser?.uid ?? ''),
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(context),
            BlocBuilder<OrderCubit, OrderState>(
              builder: (context, state) {
                if (state is OrderLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is OrderFailure) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red.withOpacity(0.6),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load orders',
                            style: context.textTheme.titleLarge?.copyWith(
                              color: context.primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.errMessage,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.secondaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (currentUser != null) {
                                context
                                    .read<OrderCubit>()
                                    .getUserOrders(userId: currentUser!.uid);
                              }
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is OrdersLoaded) {
                  final orders = state.orders;

                  if (orders.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 80,
                              color: context.secondaryTextColor.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Orders Yet',
                              style: context.textTheme.headlineSmall?.copyWith(
                                color: context.primaryTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your order history will appear here',
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final order = orders[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: OrderCard(order: order),
                          );
                        },
                        childCount: orders.length,
                      ),
                    ),
                  );
                }

                return const SliverFillRemaining(
                  child: Center(child: Text('No orders found')),
                );
              },
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: context.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'My Orders',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.primaryColor,
                context.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.receipt_long,
                    color: Colors.white.withOpacity(0.9),
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
