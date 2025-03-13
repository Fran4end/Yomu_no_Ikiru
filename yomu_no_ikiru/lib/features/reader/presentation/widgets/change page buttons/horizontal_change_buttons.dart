import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yomu_no_ikiru/features/reader/presentation/cubit/page_handler_cubit.dart';

class HorizontalChangeButtons extends StatelessWidget {
  const HorizontalChangeButtons({
    super.key,
    this.reverse = true,
  });

  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => _nextOrPreviousPage(reverse, context),
          child: Container(
            height: MediaQuery.of(context).size.height - 50,
            width: (MediaQuery.of(context).size.width / 2) * .6,
            decoration: const BoxDecoration(color: Colors.transparent),
          ),
        ),
        GestureDetector(
          onTap: () => _nextOrPreviousPage(!reverse, context),
          child: Container(
            height: MediaQuery.of(context).size.height - 50,
            width: (MediaQuery.of(context).size.width / 2) * .6,
            decoration: const BoxDecoration(color: Colors.transparent),
          ),
        ),
      ],
    );
  }

  void _nextOrPreviousPage(bool dxOrSx, BuildContext context) {
    final currentPage = context.read<PageHandlerCubit>().state.currentPage;
    if (dxOrSx) {
      context.read<PageHandlerCubit>().updateCurrentPage(currentPage + 1);
    } else {
      context.read<PageHandlerCubit>().updateCurrentPage(currentPage - 1);
    }
  }
}
