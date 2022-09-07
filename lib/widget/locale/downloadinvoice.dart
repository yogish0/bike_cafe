import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DownloadInvoice {
  Future openFile(String? url) async {
    final storage = await getApplicationDocumentsDirectory();
    var name = url?.split('/').last;
    final file = File("${storage.path}/$name");

    try {
      var response = await Dio().get(url!,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0));
      log(response.statusCode.toString());

      final fileData = file.openSync(mode: FileMode.write);
      fileData.writeFromSync(response.data);
      await fileData.close();
      if (file == null) return;
      debugPrint(file.path.toString());
      OpenFile.open(file.path);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
