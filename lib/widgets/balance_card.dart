import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class BalanceCard extends StatefulWidget {
  final String name;
  final double balance; // Novo parâmetro para o saldo

  const BalanceCard({super.key, required this.name, required this.balance});

  @override
  _BalanceCardState createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isVisible = false; // Estado para controlar se o saldo está visível

  @override
  Widget build(BuildContext context) {
    // Inicializa a formatação de datas
    initializeDateFormatting('pt_BR', null);

    // Obtendo a data atual
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, dd/MM/yyyy', 'pt_BR').format(now);

    // Formatando o saldo em reais
    String formattedBalance = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    ).format(widget.balance);

    // Valor exibido dependendo do estado de visibilidade
    String displayBalance = _isVisible
        ? formattedBalance
        : 'R\$ ${'X,XX'}'; // Quando invisível, exibe "R$ X,XX"

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF004D61),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Olá, ${widget.name}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formattedDate,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 12),

          // Linha do Saldo + Ícone de Olho
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Saldo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isVisible =
                        !_isVisible; // Alterna o estado de visibilidade
                  });
                },
                icon: Icon(
                  _isVisible
                      ? Icons.visibility_off
                      : Icons.visibility, // Troca o ícone conforme o estado
                  color: Colors.white,
                ),
              ),
            ],
          ),

          // Divider
          const Divider(
            color: Colors.white70,
            thickness: 1,
            indent: 40,
            endIndent: 40,
          ),

          const SizedBox(height: 8),

          // Conta Corrente
          const Text(
            'Conta corrente',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 8),

          // Valor do saldo
          Text(
            displayBalance, // Exibe o valor dependendo da visibilidade
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          // Adicionando a imagem abaixo do saldo
          const SizedBox(height: 16),
          Image.asset(
            'lib/assets/images/balance_card.png', // Caminho para a imagem (adapte conforme o seu caso)
            height: 200, // Tamanho da imagem
            fit: BoxFit.contain, // Como a imagem será ajustada
          ),
        ],
      ),
    );
  }
}
