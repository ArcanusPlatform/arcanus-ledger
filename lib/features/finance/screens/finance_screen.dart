import 'package:flutter/material.dart';
import '../../../database/database.dart';
import '../../../utils/responsive_utils.dart';
import '../../../widgets/custom_app_bar.dart';
import '../services/finance_service.dart';
import '../models/finance_models.dart';
import 'finance_agreement_form_screen.dart';
import 'finance_agreement_detail_screen.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen>
    with TickerProviderStateMixin {
  final _db = AppDatabase.instance;

  List<FinanceAgreement> _all = [];
  List<FinanceAgreement> _active = [];
  List<FinanceAgreement> _completed = [];
  FinanceSummary? _summary;

  bool _isLoading = true;
  String _search = '';
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final all = await _db.getAllFinanceAgreements();
      final summary = await FinanceService.buildSummary(all, _db);
      if (!mounted) return;
      setState(() {
        _all = all;
        _summary = summary;
        _applySearch();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error loading finance: $e')));
    }
  }

  void _applySearch() {
    final q = _search.toLowerCase();
    final filtered = q.isEmpty
        ? _all
        : _all.where((a) => a.customerName.toLowerCase().contains(q)).toList();

    _active =
        filtered.where((a) => a.status.toUpperCase() != 'COMPLETE').toList();
    _completed =
        filtered.where((a) => a.status.toUpperCase() == 'COMPLETE').toList();
  }

  Future<void> _openAgreement(FinanceAgreement agreement) async {
    final refreshed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FinanceAgreementDetailScreen(agreementId: agreement.id),
      ),
    );
    if (refreshed == true) _loadData();
  }

  Future<void> _newAgreement() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const FinanceAgreementFormScreen()),
    );
    if (saved == true) _loadData();
  }

  Future<void> _deleteAgreement(FinanceAgreement a) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Agreement'),
        content: Text(
            'Delete the agreement for ${a.customerName}? This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _db.deleteFinanceAgreement(a.id);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Agreement deleted')));
    }
    _loadData();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Ledger',
        subtitle: 'Agreement and repayment management',
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: AppIconSizes.appBar),
            onPressed: _newAgreement,
            tooltip: 'New Agreement',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── KPI summary row ──────────────────────────────────────────────
          _buildSummaryRow(isMobile),

          // ── Search ──────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.getScreenPadding(context),
              vertical: 8,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search customer...',
                prefixIcon:
                    const Icon(Icons.search, size: AppIconSizes.listItem),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
              ),
              onChanged: (v) {
                setState(() {
                  _search = v;
                  _applySearch();
                });
              },
            ),
          ),

          // ── Tabs ─────────────────────────────────────────────────────────
          TabBar(
            controller: _tabs,
            tabs: [
              Tab(text: 'Active (${_active.length})'),
              Tab(text: 'Completed (${_completed.length})'),
            ],
          ),

          // ── List ─────────────────────────────────────────────────────────
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabs,
                    children: [
                      _buildList(_active, isMobile,
                          emptyMsg: 'No active agreements'),
                      _buildList(_completed, isMobile,
                          emptyMsg: 'No completed agreements'),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newAgreement,
        icon: const Icon(Icons.add, size: AppIconSizes.fab),
        label: const Text('New Agreement'),
      ),
    );
  }

  // ── Summary row ───────────────────────────────────────────────────────────

  Widget _buildSummaryRow(bool isMobile) {
    final s = _summary;
    return Container(
      color: Colors.grey.shade100,
      padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
      child: Row(
        children: [
          Expanded(
              child: _kpi('Active', '${s?.activeCount ?? 0}',
                  Icons.account_balance_wallet, Colors.blue)),
          const SizedBox(width: 10),
          Expanded(
              child: _kpi(
                  'Outstanding',
                  FinanceService.formatCurrency(s?.totalOutstanding ?? 0),
                  Icons.trending_up,
                  Colors.orange)),
          const SizedBox(width: 10),
          Expanded(
              child: _kpi(
                  'Due This Week',
                  FinanceService.formatCurrency(s?.dueThisWeek ?? 0),
                  Icons.event,
                  Colors.red)),
          const SizedBox(width: 10),
          Expanded(
              child: _kpi('Completed', '${s?.completedCount ?? 0}',
                  Icons.check_circle, Colors.green)),
        ],
      ),
    );
  }

  Widget _kpi(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: AppIconSizes.listItem, color: color),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: AppTypography.mobileHeading3,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(label,
                style: TextStyle(
                    fontSize: AppTypography.mobileLabel,
                    color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  // ── Agreement list ────────────────────────────────────────────────────────

  Widget _buildList(List<FinanceAgreement> items, bool isMobile,
      {required String emptyMsg}) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet_outlined,
                size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(emptyMsg,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey.shade600)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
      itemCount: items.length,
      itemBuilder: (_, i) => _buildCard(items[i], isMobile),
    );
  }

  Widget _buildCard(FinanceAgreement a, bool isMobile) {
    final status = a.status.toUpperCase();
    final statusColor = status == 'COMPLETE'
        ? Colors.green
        : status == 'OVERDUE'
            ? Colors.red
            : Colors.blue;

    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.getCardSpacing(context)),
      child: InkWell(
        onTap: () => _openAgreement(a),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: statusColor.withAlpha(30),
                    child: Icon(Icons.person,
                        color: statusColor, size: AppIconSizes.button),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.customerName,
                            style: TextStyle(
                                fontSize:
                                    AppTypography.getBodyTextSize(context),
                                fontWeight: FontWeight.bold)),
                        Text(
                            'Started ${FinanceService.formatDate(a.agreementDate)}',
                            style: TextStyle(
                                fontSize: AppTypography.getLabelSize(context),
                                color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  _statusPill(status, statusColor),
                  PopupMenuButton<String>(
                    onSelected: (v) {
                      if (v == 'view') _openAgreement(a);
                      if (v == 'delete') _deleteAgreement(a);
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                          value: 'view',
                          child: Row(children: [
                            Icon(Icons.visibility, size: AppIconSizes.button),
                            SizedBox(width: 8),
                            Text('View'),
                          ])),
                      const PopupMenuItem(
                          value: 'delete',
                          child: Row(children: [
                            Icon(Icons.delete,
                                size: AppIconSizes.button, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ])),
                    ],
                  ),
                ],
              ),
              const Divider(height: 20),
              // Financial summary row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoChip('Loan', FinanceService.formatCurrency(a.loanAmount),
                      Colors.blue),
                  _infoChip(
                      'Repayable',
                      FinanceService.formatCurrency(a.totalRepayable),
                      Colors.purple),
                  _infoChip(
                      'Payment',
                      FinanceService.formatCurrency(a.paymentAmount),
                      Colors.teal),
                  _infoChip('Freq', a.paymentFrequency, Colors.grey.shade700),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusPill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: AppTypography.mobileLabel,
              fontWeight: FontWeight.bold,
              color: color)),
    );
  }

  Widget _infoChip(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: AppTypography.mobileLabel,
                color: Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                fontSize: AppTypography.getLabelSize(context),
                fontWeight: FontWeight.bold,
                color: color)),
      ],
    );
  }
}
