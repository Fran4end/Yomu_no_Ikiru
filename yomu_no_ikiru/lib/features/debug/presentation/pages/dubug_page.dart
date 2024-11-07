import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yomu_no_ikiru/features/manga/common/presentation/bloc/manga_bloc.dart';

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
            onPressed: () {
              context.read<MangaBloc>().add(
                    const MangaFetchSearchList(
                      maxPagesize: 20,
                      source: "MangaWorld",
                      filters: {'sort': 'most_read', "page": 1},
                      query: "",
                    ),
                  );
            },
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
