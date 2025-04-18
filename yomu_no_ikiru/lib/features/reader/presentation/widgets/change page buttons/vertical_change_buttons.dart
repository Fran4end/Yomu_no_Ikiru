import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yomu_no_ikiru/core/utils/constants.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/cubit/page_handler_cubit.dart';

/// Widget that displays the buttons to change the page vertically.
/// 
/// This widget is responsible for displaying the invisible buttons to change the page vertically.
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
              final currentPage = context.read<PageHandlerCubit>().state.currentPage;
              context.read<PageHandlerCubit>().updateCurrentPage(currentPage - 1);
            },
            child: Container(
              height: (MediaQuery.of(context).size.height / 2) * .6,
              width: MediaQuery.of(context).size.width - 50,
              decoration: const BoxDecoration(color: Colors.transparent),
            ),
          ),
          GestureDetector(
            onTap: () {
              final currentPage = context.read<PageHandlerCubit>().state.currentPage;
              context.read<PageHandlerCubit>().updateCurrentPage(currentPage + 1);
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
