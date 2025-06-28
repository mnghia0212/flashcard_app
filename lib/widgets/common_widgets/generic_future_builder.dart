// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flashcard_app/config/config.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GenericFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T data) onSuccess;
  final Widget? onLoading;
  final Widget? onError;
  final Widget? onEmpty;

  const GenericFutureBuilder({
    super.key,
    required this.future,
    required this.onSuccess,
    this.onLoading,
    this.onError,
    this.onEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return onLoading ?? const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return onError ??
              const DisplayText(
                text: "Lỗi khi tải dữ liệu",
                color: AppColors.textPrimary,
              );
        } else if (!snapshot.hasData) {
          return onEmpty ??
              const DisplayText(
                text: "Không có dữ liệu",
                color: AppColors.textPrimary,
              );
        } else {
          return onSuccess(snapshot.data as T);
        }
      },
    );
  }
}
