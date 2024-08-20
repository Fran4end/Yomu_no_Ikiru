import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yomu_no_ikiru/core/common/cubits/appuser/app_user_cubit.dart';
import 'package:yomu_no_ikiru/core/utils/show_snackbar.dart';

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
    final user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showSnackBar(context,
                  "User: ${user.id},\n${user.username},\n${user.email},\n${user.avatarUrl},");
            },
            icon: Icon(Icons.bug_report_outlined),
          ),
        ],
      ),
      body: Center(
        child: Text('Debug Page'),
      ),
    );
  }
}
