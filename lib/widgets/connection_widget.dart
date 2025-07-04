import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/pamuk_provider.dart';
import '../l10n/app_localizations.dart';

class ConnectionWidget extends StatelessWidget {
  const ConnectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<PamukProvider>(
      builder: (context, provider, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getBackgroundColor(context, provider.connectionStatus),
            border: const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
          ),
          child: Row(
            children: [
              _buildStatusIcon(context, provider.connectionStatus),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStatusTitle(localizations, provider.connectionStatus),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (provider.connectedDevice != null) ...[
                      const SizedBox(height: 4),
                      Text('${localizations.device}: ${provider.connectedDevice}', style: Theme.of(context).textTheme.bodySmall),
                    ],
                    if (provider.connectionStatus == ConnectionStatus.connecting) ...[
                      const SizedBox(height: 4),
                      Text(localizations.deviceUnauthorizedDescription, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildActionButton(context, localizations, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusIcon(BuildContext context, ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.disconnected:
        return const Icon(Icons.phone_android, color: Colors.grey, size: 32);
      case ConnectionStatus.connecting:
        return const SizedBox(width: 32, height: 32, child: CircularProgressIndicator(strokeWidth: 3));
      case ConnectionStatus.connected:
        return Icon(Icons.check_circle, color: Colors.green[600], size: 32);
      case ConnectionStatus.error:
        return Icon(Icons.error, color: Theme.of(context).colorScheme.error, size: 32);
    }
  }

  String _getStatusTitle(AppLocalizations localizations, ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.disconnected:
        return localizations.noDeviceConnected;
      case ConnectionStatus.connecting:
        return localizations.connecting;
      case ConnectionStatus.connected:
        return localizations.connected;
      case ConnectionStatus.error:
        return localizations.error;
    }
  }

  Color _getBackgroundColor(BuildContext context, ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.disconnected:
        return Theme.of(context).colorScheme.surface;
      case ConnectionStatus.connecting:
        return Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3);
      case ConnectionStatus.connected:
        return Colors.green[50] ?? Theme.of(context).colorScheme.surface;
      case ConnectionStatus.error:
        return Theme.of(context).colorScheme.errorContainer.withOpacity(0.3);
    }
  }

  Widget _buildActionButton(BuildContext context, AppLocalizations localizations, PamukProvider provider) {
    switch (provider.connectionStatus) {
      case ConnectionStatus.disconnected:
        return ElevatedButton.icon(
          onPressed: provider.isLoading ? null : () => provider.connectToDevice(),
          icon: const Icon(Icons.usb),
          label: Text(localizations.connectToDevice),
        );
      case ConnectionStatus.error:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: provider.isLoading ? null : () => provider.connectToDevice(),
              icon: const Icon(Icons.refresh),
              label: Text(localizations.connectToDevice),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'restart_adb') {
                  await provider.restartAdbServer();
                } else if (value == 'troubleshoot') {
                  _showTroubleshootDialog(context, localizations);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'restart_adb',
                  child: ListTile(leading: const Icon(Icons.refresh), title: Text(localizations.restartAdbServer), contentPadding: EdgeInsets.zero),
                ),
                PopupMenuItem(
                  value: 'troubleshoot',
                  child: ListTile(leading: const Icon(Icons.help), title: Text(localizations.troubleshooting), contentPadding: EdgeInsets.zero),
                ),
              ],
              child: const Icon(Icons.more_vert),
            ),
          ],
        );
      case ConnectionStatus.connecting:
        return ElevatedButton.icon(
          onPressed: null,
          icon: const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
          label: Text(localizations.connecting),
        );
      case ConnectionStatus.connected:
        return ElevatedButton.icon(
          onPressed: () => provider.disconnectFromDevice(),
          icon: const Icon(Icons.usb_off),
          label: Text(localizations.disconnect),
          style: ElevatedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
        );
    }
  }

  void _showTroubleshootDialog(BuildContext context, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.troubleshootingTitle),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(localizations.troubleshootingDescription, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(localizations.adbInstallation),
              Text(localizations.installAndroidSDK),
              Text(localizations.addAdbToPath),
              Text(localizations.testAdbDevices),
              const SizedBox(height: 12),
              Text(localizations.deviceSettings),
              Text(localizations.enableDeveloperOptions),
              Text(localizations.enableUsbDebugging),
              Text(localizations.setUsbMode),
              const SizedBox(height: 12),
              Text(localizations.connectionTroubleshooting),
              Text(localizations.useQualityUSBCable),
              Text(localizations.tryDifferentPorts),
              Text(localizations.acceptUsbDialog),
              const SizedBox(height: 12),
              Text(localizations.permissions),
              Text(localizations.runAsAdmin),
              Text(localizations.checkUsbAuthorization),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(localizations.close))],
      ),
    );
  }
}
