import 'dart:async';
import 'dart:io';

import 'package:FEhViewer/common/global.dart';
import 'package:FEhViewer/utils/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum ShowType {
  rename,
  create,
  delete,
}

class WebMySetting extends StatefulWidget {
  @override
  _WebMySettingState createState() => _WebMySettingState();
}

class _WebMySettingState extends State<WebMySetting> {
  // WebViewController _controller;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  Future<void> _future;

  final TextEditingController _nameController = TextEditingController();

  Future<void> _getCookies() async {
    final WebviewCookieManager cookieManager = WebviewCookieManager();
    final List<Cookie> cookies =
        (await Api.cookieJar).loadForRequest(Uri.parse(Api.getBaseUrl()));
    Global.logger.d(cookies.join('\n'));
    await cookieManager?.setCookies(cookies);
  }

  @override
  void initState() {
    super.initState();
    _future = _getCookies();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  JavascriptChannel _deleteJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Delete',
        onMessageReceived: (JavascriptMessage message) {
          Global.logger.d(message.message);
          if (message.message.contains('delete the profile')) {
            _showAlterDilog(ShowType.delete,
                defaultText: message.message, textField: false);
          }
        });
  }

  JavascriptChannel _promptJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Prompt',
        onMessageReceived: (JavascriptMessage message) {
          Global.logger.d(message.message);
          List<String> _msgs = message.message.split('#@#');
          final String _msg = _msgs[0];
          final String _defaultText = _msgs[1];
          if (_msg.contains('new name')) {
            Global.logger.d('重命名 $_defaultText');
            _showAlterDilog(ShowType.rename, defaultText: _defaultText);
          } else if (_msg.contains('new profile')) {
            Global.logger.d('新建配置 $_defaultText');
            _showAlterDilog(ShowType.create, defaultText: _defaultText);
          }
        });
  }

  Future<void> _showAlterDilog(
    ShowType type, {
    @required String defaultText,
    bool textField = true,
  }) {
    final String _title = type == ShowType.rename ? '重命名配置' : '新建配置';
    _nameController.text = defaultText;

    return showCupertinoDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(type != ShowType.delete ? _title : defaultText),
          content: Container(
            child: textField
                ? CupertinoTextField(
                    controller: _nameController,
                    autofocus: true,
                    onEditingComplete: () {
                      // 点击键盘完成 提交
                      if (_nameController.text.trim().isNotEmpty) {
                        if (type == ShowType.rename) {
                          _renameProfile(_nameController.text.trim());
                        } else if (type == ShowType.create) {
                          _creatNewProfile(_nameController.text.trim());
                        } else if (type == ShowType.delete) {
                          _deleteProfile();
                        }
                      }
                    },
                  )
                : Container(),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('确定'),
              onPressed: () {
                // 提交
                if (_nameController.text.trim().isNotEmpty) {
                  if (type == ShowType.rename) {
                    _renameProfile(_nameController.text.trim());
                  } else if (type == ShowType.create) {
                    _creatNewProfile(_nameController.text.trim());
                  } else if (type == ShowType.delete) {
                    _deleteProfile();
                  }
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _renameProfile(String profileName) async {
    try {
      final String javascript = '''
      document.getElementById("profile_action").value = "rename";
		  document.getElementById("profile_name").value = $profileName;
		  do_profile_post();
      ''';
      (await _controller.future)?.evaluateJavascript(javascript);
    } catch (_) {}
  }

  Future<void> _creatNewProfile(String profileName) async {
    try {
      final String javascript = '''
      document.getElementById("profile_action").value = "create";
		  document.getElementById("profile_name").value = $profileName;
		  do_profile_post();
      ''';
      (await _controller.future)?.evaluateJavascript(javascript);
    } catch (_) {}
  }

  Future<void> _deleteProfile() async {
    try {
      const String javascript = '''
      document.getElementById("profile_action").value = "delete";
		  do_profile_post();
      ''';
      (await _controller.future)?.evaluateJavascript(javascript);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final CupertinoPageScaffold cpf = CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Ehentai设置'),
          trailing: CupertinoButton(
            padding: const EdgeInsets.all(0),
            child: const Icon(FontAwesomeIcons.checkCircle),
            onPressed: () async {
              // (await _controller.future).reload();
              (await _controller.future).evaluateJavascript(
                  'document.querySelector("#apply > input[type=submit]").click();');
            },
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<void>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Container();
                } else {
                  return WebView(
                    initialUrl: '${Api.getBaseUrl()}/uconfig.php',
                    javascriptMode: JavascriptMode.unrestricted,
                    javascriptChannels: <JavascriptChannel>{
                      _promptJavascriptChannel(context),
                      _deleteJavascriptChannel(context),
                    },
                    onWebViewCreated: (WebViewController webViewController) {
                      // _controller = webViewController;
                      _controller.complete(webViewController);
                    },
                    onPageStarted: (String url) {
                      print('Page started loading: $url');
                    },
                    onPageFinished: (String url) async {
                      print('Page Finished loading: $url');
                      try {
                        const String javascript = '''
                        window.prompt = function (msg,defaultText){
                          Prompt.postMessage(msg + '#@#' + defaultText);
                        }
                        window.confirm = function (msg){
                          Delete.postMessage(msg);
                        }
                        ''';
                        (await _controller.future)
                            ?.evaluateJavascript(javascript);
                      } catch (_) {}
                    },
                    gestureNavigationEnabled: true,
                    navigationDelegate: (NavigationRequest request) {
                      if (!request.url.endsWith('uconfig.php')) {
                        print('阻止打开 ${request.url}');
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    },
                  );
                }
              }),
        ));

    return cpf;
  }
}