import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yomu_no_ikiru/constants.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/bloc/reader_bloc.dart';

class VerticalChangeButtons extends StatelessWidget {
  const VerticalChangeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              final currentPage = (context.read<ReaderBloc>().state as ReaderSuccess).currentPage;
              context.read<ReaderBloc>().add(
                    ReaderChangePage(
                      newPageIndex: currentPage - 1,
                    ),
                  );
            },
            child: Container(
              height: (MediaQuery.of(context).size.height / 2) * .6,
              width: MediaQuery.of(context).size.width - 50,
              decoration: const BoxDecoration(color: Colors.transparent),
            ),
          ),
          GestureDetector(
            onTap: () {
              final currentPage = (context.read<ReaderBloc>().state as ReaderSuccess).currentPage;
              context.read<ReaderBloc>().add(
                    ReaderChangePage(
                      newPageIndex: currentPage + 1,
                    ),
                  );
            },
            child: Container(
              height: (MediaQuery.of(context).size.height / 2) * .6,
              width: MediaQuery.of(context).size.width - 50,
              decoration: const BoxDecoration(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}
