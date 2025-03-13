import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:bytebank/config/dio_client.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:bytebank/widgets/button.dart';
import 'package:bytebank/widgets/statement/statement_item.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file_plus/open_file_plus.dart';

const String firebaseAppName = 'tech-challenge-fase-3-abc';

class Statement extends StatefulWidget {
  const Statement({super.key});

  @override
  State<Statement> createState() => _StatementState();
}

class _StatementState extends State<Statement> {
  final DioClient _dioClient = DioClient();
  final TextStyle footerLinksStyle = TextStyle(color: Colors.green);
  final String statementFilePath = 'files/latest_statement.txt';

  List<dynamic> _transactions = [];
  List<dynamic> _filteredTransactions = [];
  int _sortDirection = 1;
  int _filterMode = 0;
  IconData _sortingIcon = Icons.arrow_downward;
  IconData _filteringIcon = Icons.sync_alt;
  bool _loadingList = false;
  bool? _loading;
  bool _fileUploaded = false;

  Future<List<dynamic>> _loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('user_id');

    Response response = await _dioClient.dio.get(
      '/$user_id/transactions',
    );

    return response.data['result'];
  }

  void _sortTransactions() {
    setState(() {
      if (_sortDirection == 1) {
        _sortDirection = -1;
        _sortingIcon = Icons.arrow_downward;
      } else {
        _sortDirection = 1;
        _sortingIcon = Icons.arrow_upward;
      }

      _applySortDirection();
    });
  }

  void _applySortDirection() {
    _filteredTransactions.sort((a, b) {
      return b['date'].compareTo(a['date']) * _sortDirection;
    });
  }

  @override
  void initState() {
    super.initState();
    _reloadTransactions();
  }

  Future<void> _reloadTransactions() async {
    setState(() => _loadingList = true);

    await Future.delayed(Duration(seconds: 1));

    _loadTransactions().then((response) {
      setState(() {
        _loadingList = false;
        _transactions = response;
        _filteredTransactions = _transactions.toList();

        _applySortDirection();
      });
    });
  }

  Future<void> _uploadFile() async {
    String csv = 'Transaction Type,Amount,Description,Date\n';

    _filteredTransactions.forEach((transaction) {
      final line = [
        transaction['transactionType'],
        transaction['amount'],
        transaction['description'],
        transaction['date'],
      ];

      csv = '$csv${line.join(',')}\n';
    });

    try {
      final Reference storageRef = FirebaseStorage.instance.ref();
      final fileRef = storageRef.child(statementFilePath);
      final uploadTask = fileRef.putString(csv);

      setState(() => _loading = true);

      final taskSnapshot = await uploadTask.whenComplete(() => null);
      await taskSnapshot.ref.getDownloadURL();

      setState(() {
        _loading = false;
        _fileUploaded = true;
      });

      print('Arquivo enviado!');
    } catch (e) {
      print('Falha ao fazer upload do arquivo: $e');
    }
  }

  Future<void> _downloadFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final Reference storageRef = FirebaseStorage.instance.ref();
      final fileRef = storageRef.child(statementFilePath);
      final fileData = await fileRef.getData();

      String downloadPath = '${directory.path}/latest_statement.txt';
      File downloadFile = File(downloadPath);

      downloadFile.writeAsString(String.fromCharCodes(fileData!));

      OpenFile.open(downloadPath);
    } catch (e) {
      print('Falha ao fazer baixar do arquivo: $e');
    }
  }

  Future<void> _deleteFile() async {
    try {
      final Reference storageRef = FirebaseStorage.instance.ref();
      final fileRef = storageRef.child(statementFilePath);

      setState(() => _loading = true);

      fileRef.delete();

      setState(() {
        _loading = false;
        _fileUploaded = false;
      });
    } catch (e) {
      print('Falha ao fazer apagar o arquivo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: AppConstants.cardLightBackground,
      child: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Extrato',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Builder(builder: (context) {
                  if (_loadingList) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppConstants.baseBlueBytebank,
                        strokeWidth: 3,
                      ),
                    );
                  } else {
                    // Filter Button
                    return Row(
                      children: [
                        // Sort Button
                        CustomButton(
                          onPressed: _sortTransactions,
                          type: ButtonType.icon,
                          icon: _sortingIcon,
                          color: AppConstants.baseBlueBytebank,
                        ),
                        CustomButton(
                          onPressed: _reloadTransactions,
                          type: ButtonType.icon,
                          icon: Icons.autorenew,
                          color: AppConstants.baseBlueBytebank,
                        ),
                      ],
                    );
                  }
                }),
              ],
            ),

            // Items
            Builder(builder: (context) {
              if (_filteredTransactions.length > 0) {
                return Column(
                  children: [
                    ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: _filteredTransactions.length.clamp(0, 3),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SizedBox(height: 12),
                            StatementItem(
                              transaction: _filteredTransactions[index],
                            ),
                          ],
                        );
                      },
                    ),

                    // Space
                    SizedBox(height: 15),

                    Builder(builder: (context) {
                      List<TextButton> buttons = [];

                      if (_loading == true) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppConstants.baseGreenBytebank,
                            strokeWidth: 3,
                          ),
                        );
                      }

                      if (!_fileUploaded) {
                        buttons = [
                          TextButton(
                            onPressed: _uploadFile,
                            child: Text('Exportar', style: footerLinksStyle),
                          )
                        ];
                      } else {
                        buttons = [
                          TextButton(
                            onPressed: _downloadFile,
                            child: Text('Baixar', style: footerLinksStyle),
                          ),
                          TextButton(
                            onPressed: _deleteFile,
                            child:
                                Text('Apagar arquivo', style: footerLinksStyle),
                          )
                        ];
                      }

                      // Footer Text Buttons
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: buttons,
                      );
                    })
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      'Nenhum transação ainda.',
                      style: TextStyle(
                        color: AppConstants.additionalInfoColor,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
