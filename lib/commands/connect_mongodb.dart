import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:parkmate/providers/app_provider.dart';
import 'package:parkmate/widgets/snackbar.dart';
import 'package:provider/provider.dart';

Future<Db> connectMongoDB(BuildContext context) async {
  AppProvider appProvider = context.read<AppProvider>();
  try {
    String? password = dotenv.env['MONGODB_PASSWORD'];
    if (password == null) {
      throw Exception('MONGODB_PASSWORD is not set');
    }
    appProvider.db = await Db.create(
        "mongodb+srv://firebase3135:$password@parkmate.z0okwas.mongodb.net/parkmate?retryWrites=true&w=majority&appName=parkmate");
    return appProvider.db!;
  } catch (e) {
    showInSnackBar(context, e.toString(), isError: true);
  }
  return appProvider.db!;
}
