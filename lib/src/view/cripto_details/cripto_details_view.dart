import 'package:cripto/src/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/cripto_details.dart';
import 'cripto_details_controller.dart';

class DetailsPage extends StatelessWidget {
  final String criptoId;

  const DetailsPage({super.key, required this.criptoId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CriptoDetailsController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadDetails(criptoId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhes da Moeda',
          style:
              TextStyle(color: AppColors.bgColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshDetails,
          ),
        ],
      ),
      body: Obx(() {
        final details = controller.details.value;

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.error.value.toString()),
                ElevatedButton(
                  onPressed: controller.refreshDetails,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        if (details == null) {
          return const Center(child: Text('Nenhum detalhe disponível'));
        }

        return _buildDetailsView(details);
      }),
    );
  }

  Widget _buildDetailsView(CriptoDetails details) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(details),
          _buildStatsSection(details),
          _buildPriceChartSection(details),
          _buildDescriptionSection(details),
          _buildLinksSection(details),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(CriptoDetails details) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          details.images?.small ?? '',
          width: 64,
          height: 64,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                details.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                details.symbol.toUpperCase(),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'R\$${details.marketData!.currentPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${details.marketData!.priceChangePercentage24h.toStringAsFixed(2)}%',
              style: TextStyle(
                color: details.marketData!.priceChangePercentage24h >= 0
                    ? Colors.green
                    : Colors.red,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection(CriptoDetails details) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  _buildStatItem('Volume 24h',
                      'R\$${details.marketData!.totalVolume.toStringAsFixed(2)}'),
                  _buildStatItem('Capitalização',
                      'R\$${details.marketData!.marketCap.toStringAsFixed(2)}'),
                  _buildStatItem(
                      'Ranking', '#${details.marketData!.marketCapRank}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceChartSection(CriptoDetails details) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Variação de Preço (7 dias)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: details.marketData!.sparkline7d.length.toDouble() - 1,
                  minY: details.marketData!.sparkline7d
                      .reduce((a, b) => a < b ? a : b),
                  maxY: details.marketData!.sparkline7d
                      .reduce((a, b) => a > b ? a : b),
                  lineBarsData: [
                    LineChartBarData(
                      spots: details.marketData!.sparkline7d
                          .asMap()
                          .entries
                          .map((e) {
                        return FlSpot(e.key.toDouble(), e.value);
                      }).toList(),
                      isCurved: true,
                      color: details.marketData!.priceChangePercentage24h >= 0
                          ? Colors.green
                          : Colors.red,
                      barWidth: 2,
                      belowBarData: BarAreaData(
                        show: true,
                        color: details.marketData!.priceChangePercentage24h >= 0
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                      ),
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(CriptoDetails details) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sobre o Projeto',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              details.description,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinksSection(CriptoDetails details) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Links Oficiais',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (details.links['homepage']!.isNotEmpty)
                    _buildLinkChip('Website', details.links['homepage']!),
                  if (details.links['whitepaper']!.isNotEmpty)
                    _buildLinkChip('Whitepaper', details.links['whitepaper']!),
                  if (details.links['twitter']!.isNotEmpty)
                    _buildLinkChip('Twitter', details.links['twitter']!),
                  if (details.links['reddit']!.isNotEmpty)
                    _buildLinkChip('Reddit', details.links['reddit']!),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinkChip(String label, String url) {
    return ActionChip(
      avatar: const Icon(Icons.open_in_new, size: 16),
      label: Text(label),
      onPressed: () => launchUrl(Uri.parse(url)),
    );
  }
}
