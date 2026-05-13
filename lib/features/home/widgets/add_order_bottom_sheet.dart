import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/constant/app_styles.dart';
import 'package:enjoy_app/core/widgets/app_text_button.dart';
import 'package:enjoy_app/features/home/widgets/custom_order_text_field.dart';
import 'package:enjoy_app/features/home/widgets/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Bottom sheet for adding new orders/products to a session
///
/// Usage:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   builder: (_) => AddOrderBottomSheet(
///     onAddOrder: (order) {
///       setState(() {
///         orders.add(order);
///       });
///     },
///   ),
/// );
/// ```
class AddOrderBottomSheet extends StatefulWidget {
  final Function(OrderModel) onAddOrder;

  const AddOrderBottomSheet({super.key, required this.onAddOrder});

  @override
  State<AddOrderBottomSheet> createState() => _AddOrderBottomSheetState();
}

class _AddOrderBottomSheetState extends State<AddOrderBottomSheet> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
    noteController.dispose();
    super.dispose();
  }

  /// Validate and create a new order
  void _addOrder() {
    // Validate product name
    if (productNameController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter product name');
      return;
    }

    // Validate price
    final price = double.tryParse(priceController.text);
    if (price == null || price < 0) {
      _showErrorSnackBar('Please enter a valid price');
      return;
    }

    // Create order
    final order = OrderModel(
      name: productNameController.text.trim(),
      price: price,
      note: noteController.text.trim().isEmpty
          ? null
          : noteController.text.trim(),
    );

    // Call callback and close bottom sheet
    widget.onAddOrder(order);
    Navigator.pop(context);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkPrimaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 20.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // HEADER
            Center(child: Text('Add Order', style: AppStyle.font25WhiteBold)),
            Gap(20.h),

            // PRODUCT NAME FIELD
            Text('Product Name', style: AppStyle.font18WhiteW500),
            Gap(8.h),
            CustomOrderTextField(
              hintText: 'e.g., Tea, Coffee, Indomie, ',
              keyboardType: TextInputType.text,
              nameController: productNameController,
            ),
            Gap(16.h),

            // PRICE FIELD
            Text('Price', style: AppStyle.font18WhiteW500),
            Gap(8.h),
            CustomOrderTextField(
              hintText: '0.00',
              nameController: priceController,
              keyboardType: TextInputType.number,
              prefixText: '\$ ',
            ),

            Gap(16.h),

            // NOTE FIELD (OPTIONAL)
            Text('Note (Optional)', style: AppStyle.font18WhiteW500),
            Gap(8.h),
            CustomOrderTextField(
              hintText: 'e.g., pay or not',
              keyboardType: TextInputType.text,
              nameController: noteController,
              maxLine: 3,
            ),
            Gap(24.h),
            // ACTION BUTTONS
            Row(
              children: [
                Expanded(
                  child: AppTextButton(
                    buttonText: 'CANCEL',
                    backgroundColor: Colors.grey,
                    textStyle: AppStyle.font18WhiteW500,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: AppTextButton(
                    buttonText: 'ADD ORDER',
                    backgroundColor: AppColors.greenColor,
                    textStyle: AppStyle.font18WhiteW500,
                    onPressed: _addOrder,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
