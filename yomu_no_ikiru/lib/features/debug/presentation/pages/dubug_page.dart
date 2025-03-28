import 'package:flutter/material.dart';

class DebugPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const DebugPage());
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bug_report_outlined),
          ),
        ],
      ),
      body: const Center(
        child: Text('Debug Page'),
      ),
    );
  }
}
