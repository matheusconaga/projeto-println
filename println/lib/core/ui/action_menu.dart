import 'package:flutter/material.dart';
import 'package:println/core/theme/app_colors.dart';

class ActionMenu extends StatelessWidget {
  final Future<void> Function()? onEdit;
  final Future<void> Function()? onDelete;

  const ActionMenu({
    super.key,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),

      onSelected: (value) async {
        if (value == "edit") {
          await onEdit?.call();
        }

        if (value == "delete") {
          await onDelete?.call();
        }
      },

      itemBuilder: (_) => [
        PopupMenuItem(
          value: "edit",
          child: Row(
            children: const [
              Icon(
                Icons.edit,
                color: AppColors.warning,
                size: 20,
              ),
              SizedBox(width: 10),
              Text("Editar"),
            ],
          ),
        ),

        PopupMenuItem(
          value: "delete",
          child: Row(
            children: const [
              Icon(
                Icons.delete,
                color: AppColors.danger,
                size: 20,
              ),
              SizedBox(width: 10),
              Text("Excluir"),
            ],
          ),
        ),
      ],
    );
  }
}