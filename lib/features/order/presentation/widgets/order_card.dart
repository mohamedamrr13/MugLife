import 'package:drinks_app/features/order/data/models/order_model.dart';
import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.dividerColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Divider(height: 1, color: context.dividerColor.withOpacity(0.3)),
          _buildOrderItems(context),
          Divider(height: 1, color: context.dividerColor.withOpacity(0.3)),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order.id?.substring(0, 8).toUpperCase() ?? 'N/A'}',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy - hh:mm a').format(order.createdAt),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusChip(context),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color statusColor;
    switch (order.status) {
      case OrderStatus.pending:
        statusColor = Colors.orange;
        break;
      case OrderStatus.confirmed:
        statusColor = Colors.blue;
        break;
      case OrderStatus.processing:
        statusColor = Colors.purple;
        break;
      case OrderStatus.shipped:
        statusColor = Colors.indigo;
        break;
      case OrderStatus.delivered:
        statusColor = Colors.green;
        break;
      case OrderStatus.cancelled:
        statusColor = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        order.statusText,
        style: context.textTheme.bodySmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildOrderItems(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items (${order.totalItems})',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: 12),
          ...order.items.take(3).map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: context.dividerColor.withOpacity(0.3),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.productImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.local_drink,
                              color: context.secondaryTextColor,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.primaryTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${item.size} × ${item.quantity}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
          if (order.items.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                '+${order.items.length - 3} more items',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.secondaryTextColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Amount',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${order.totalAmount.toStringAsFixed(2)}',
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildPaymentBadge(context),
              const SizedBox(width: 8),
              if (order.status == OrderStatus.pending ||
                  order.status == OrderStatus.confirmed)
                _buildCancelButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color:
            order.isPaid
                ? Colors.green.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              order.isPaid
                  ? Colors.green.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            order.paymentMethod == PaymentMethod.card
                ? Icons.credit_card
                : Icons.money,
            size: 16,
            color: order.isPaid ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            order.isPaid ? 'Paid' : 'Unpaid',
            style: context.textTheme.bodySmall?.copyWith(
              color: order.isPaid ? Colors.green : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        // TODO: Implement cancel order
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cancel Order'),
            content: const Text('Are you sure you want to cancel this order?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Implement cancel logic here
                },
                child: const Text('Yes', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.red.withOpacity(0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(
        'Cancel',
        style: context.textTheme.bodySmall?.copyWith(
          color: Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
