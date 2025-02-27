import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easy_permission/easy_permissions.dart';
import 'package:flutter_scankit/flutter_scankit.dart';
import 'package:http/http.dart' as http;

import '../components/dialog/confirm.dart';

const permissions = [Permissions.READ_EXTERNAL_STORAGE, Permissions.CAMERA];

const permissionGroup = [PermissionGroup.Camera, PermissionGroup.Photos];

class CodeScanPage extends StatefulWidget {
  const CodeScanPage({super.key});

  @override
  State<CodeScanPage> createState() => _CodeScanPageState();
}

class _CodeScanPageState extends State<CodeScanPage> {
  ScanKit? scanKit;
  String code = "null";

  @override
  void initState() {
    super.initState();
    scanKit = ScanKit();
    scanKit!.onResult.listen((val) async {
      final result = await ConfirmDialog.show(
            context,
            title: "检测到您扫描了新的二维码/条码",
            content: "您刚刚扫描的内容为：${val.originalValue}\n"
                "请您确认是否添加，防止误添加",
            cancelText: "不添加",
            confirmText: "确认添加",
          ) ??
          true;

      debugPrint(
          "scanning result:${val.originalValue}  scanType:${val.scanType}");
      if (result) {
        if (_doFormPost(val.originalValue)) {
          setState(() {
            code = "ok";
          });
        } else {
          code = "no";
        }
      }
    });

    FlutterEasyPermission().addPermissionCallback(
        onGranted: (requestCode, perms, perm) {
          startScan();
        },
        onDenied: (requestCode, perms, perm, isPermanent) {});
  }

  @override
  void dispose() {
    scanKit?.dispose();
    super.dispose();
  }

  Future<void> startScan() async {
    try {
      await scanKit?.startScan(
          scanTypes: ScanTypes.codaBar.bit |
              ScanTypes.upcCodeA.bit |
              ScanTypes.upcCodeE.bit |
              ScanTypes.itf14.bit |
              ScanTypes.ean8.bit |
              ScanTypes.ean13.bit |
              ScanTypes.code39.bit |
              ScanTypes.code93.bit |
              ScanTypes.code128.bit);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              code,
              maxLines: 2,
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              child: const Text("扫描二维码"),
              onPressed: () async {
                if (!await FlutterEasyPermission.has(
                    perms: permissions, permsGroup: permissionGroup)) {
                  FlutterEasyPermission.request(
                      perms: permissions, permsGroup: permissionGroup);
                } else {
                  startScan();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  // post请求 之后需要重新设计到通用请求库调用
  _doFormPost(id) async {
    var url = Uri.parse('http://192.168.101.3:3000/book');
    var params = {'id': id};
    var json = jsonEncode(params);
    var response = await http
        .post(url, body: json, headers: {'content-type': 'application/json'});
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
