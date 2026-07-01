import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../widgets/custom_app_bar.dart';
import 'workspace_screen.dart';
import 'suppliers_screen.dart';
import 'products_screen.dart';
import 'sales_screen.dart';
import 'customer_receipts_screen.dart';
import 'expenses_screen.dart';
import 'profit_loss_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';
import '../features/finance/screens/finance_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final maxIndex = isSmallScreen ? 2 : 9;

    if (_selectedIndex > maxIndex) {
      _selectedIndex = 0;
    }

    return Scaffold(
      body: isSmallScreen
          ? _buildMobileScreen()
          : _buildDesktopScreens()[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: isSmallScreen
            ? const [
                NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: 'Customers',
                ),
                NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2),
                  label: 'Products',
                ),
                NavigationDestination(
                  icon: Icon(Icons.more_horiz_outlined),
                  selectedIcon: Icon(Icons.more_horiz),
                  label: 'More',
                ),
              ]
            : const [
                NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: 'Customers',
                ),
                NavigationDestination(
                  icon: Icon(Icons.local_shipping_outlined),
                  selectedIcon: Icon(Icons.local_shipping),
                  label: 'Suppliers',
                ),
                NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2),
                  label: 'Products',
                ),
                NavigationDestination(
                  icon: Icon(Icons.point_of_sale_outlined),
                  selectedIcon: Icon(Icons.point_of_sale),
                  label: 'Sales',
                ),
                NavigationDestination(
                  icon: Icon(Icons.payment_outlined),
                  selectedIcon: Icon(Icons.payment),
                  label: 'Receipts',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: 'Expenses',
                ),
                NavigationDestination(
                  icon: Icon(Icons.analytics_outlined),
                  selectedIcon: Icon(Icons.analytics),
                  label: 'P&L',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart),
                  label: 'Reports',
                ),
                NavigationDestination(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  selectedIcon: Icon(Icons.account_balance_wallet),
                  label: 'Ledger',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
      ),
    );
  }

  Widget _buildMobileScreen() {
    switch (_selectedIndex) {
      case 0:
        return const WorkspaceScreen();
      case 1:
        return const ProductsScreen();
      case 2:
        return _buildMoreScreen();
      default:
        return const WorkspaceScreen();
    }
  }

  List<Widget> _buildDesktopScreens() {
    return const [
      WorkspaceScreen(),
      SuppliersScreen(),
      ProductsScreen(),
      SalesScreen(),
      CustomerReceiptsScreen(),
      ExpensesScreen(),
      ProfitLossScreen(),
      ReportsScreen(),
      FinanceScreen(),
      SettingsScreen(),
    ];
  }

  Widget _buildMoreScreen() {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'More',
        subtitle: 'Other business tools',
        showLogout: false,
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
        children: [
          _buildMoreMenuItem(
            'Ledger',
            'Agreement and repayment management',
            Icons.account_balance_wallet,
            Colors.teal,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FinanceScreen()),
            ),
          ),
          _buildMoreMenuItem(
            'Suppliers',
            'Manage your suppliers',
            Icons.local_shipping,
            Colors.indigo,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SuppliersScreen()),
            ),
          ),
          _buildMoreMenuItem(
            'Sales',
            'Create and manage sales',
            Icons.point_of_sale,
            Colors.teal,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SalesScreen()),
            ),
          ),
          _buildMoreMenuItem(
            'Customer Receipts',
            'Record customer payments',
            Icons.payment,
            Colors.purple,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CustomerReceiptsScreen(),
              ),
            ),
          ),
          _buildMoreMenuItem(
            'Expenses',
            'Track and manage business expenses',
            Icons.receipt_long,
            Colors.orange,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExpensesScreen()),
            ),
          ),
          _buildMoreMenuItem(
            'Profit & Loss',
            'View financial performance',
            Icons.analytics,
            Colors.green,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfitLossScreen(),
              ),
            ),
          ),
          _buildMoreMenuItem(
            'Reports',
            'Generate business reports',
            Icons.bar_chart,
            Colors.blue,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReportsScreen()),
            ),
          ),
          _buildMoreMenuItem(
            'Settings',
            'App settings and preferences',
            Icons.settings,
            Colors.grey,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          _buildMoreMenuItem(
            'Logout',
            'Sign out of your account',
            Icons.logout,
            Colors.red,
            _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildMoreMenuItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.getCardSpacing(context)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(51),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
