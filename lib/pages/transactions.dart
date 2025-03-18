// ignore_for_file: unused_import

import 'package:bytebank/config/auth_service.dart';
import 'package:bytebank/forms/transaction-form.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:bytebank/widgets/button.dart';
import 'package:bytebank/widgets/drawer-generic.dart';
import 'package:bytebank/widgets/menu/drawer.dart';
import 'package:bytebank/widgets/paginated-grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction.provider.dart';
import '../models/transaction.dart';
import '../widgets/transaction_card.dart';
import '../services/file_upload.service.dart';

class TransactionsPage extends StatelessWidget {
  TransactionsPage({super.key});
  final ValueNotifier<bool> _reloadNotifier = ValueNotifier<bool>(false);
  AuthService authService = AuthService();
  String? token;
  String? userId;

  @override
  Widget build(BuildContext context) {
    _reloadNotifier;
    _initializeAsyncDependencies();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "",
                  textAlign: TextAlign.center,
                ),
                const Icon(
                  Icons.account_circle_outlined,
                  size: 35,
                ),
              ],
            ),
          ),
        ),
        toolbarHeight: 60,
      ),
      drawer: DrawerComponent(),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Add Filter options
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      text: 'Adicionar transação',
                      onPressed: () => _addTransaction(context),
                      type: ButtonType.elevated,
                      color: AppConstants.baseBlueBytebank,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Container(
                height: 500,
                child: DynamicDataTable(
                  onEdit: (data) {
                    _openDrawerForm(context, 'edit', data);
                  },
                  onView: (data) {
                    _openDrawerForm(context, 'view', data);
                  },
                  onDelete: (data) {
                    _openDrawerForm(context, 'delete', data);
                  },
                  reloadNotifier: _reloadNotifier,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _addTransaction(BuildContext context) async {
    _openDrawerForm(context, 'add', null);
  }

  void _openDrawerForm(BuildContext context, String type,
      Map<String, dynamic>? transactionData) {
    showModalBottomSheet(
      context: context,
      backgroundColor: type == 'delete' ? AppConstants.error : null,
      builder: (BuildContext context) {
        return Padding(
            padding: const EdgeInsets.all(24.0),
            child: TransactionForm(
              isPage1: true,
              userId: userId ?? '',
              pageName: 'TransactionsPage',
              formMode: type,
              doExtraAction: () => _reloadTable(context),
              transaction: transactionData ?? transactionData,
            ));
      },
    );
  }

  void _reloadTable(BuildContext context) {
    _reloadNotifier.value = !_reloadNotifier.value;
    Navigator.pop(context);
  }

  void _initializeAsyncDependencies() async {
    token = await authService.getToken();
    userId = await authService.getUserId();
  }
}
