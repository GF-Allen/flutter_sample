import 'package:flutter/material.dart';
import 'package:flutter_sample/model/message_model.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class SembastPage extends StatefulWidget {
  const SembastPage({super.key});

  @override
  State<SembastPage> createState() => _SembastPageState();
}

class _SembastPageState extends State<SembastPage> {
  int _index = 1;

  int _queryIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  final _messageStore = intMapStoreFactory.store('message');

  Future<Database> get _db async => await AppDatabase.instance.database;

  void _inset() async {
    var messageModel = MessageModel(uid: '${_index}', content: '你好啊: ${_index}', state: 0);
    var add = await _messageStore.add(await _db, messageModel.toJson());
    messageModel = messageModel.copyWith(id: add);
    print('inset: $messageModel');
    _index++;
  }

  void _update() async {
    var result = await _messageStore.findFirst(await _db, finder: Finder(filter: Filter.byKey(3)));
    if (result != null) {
      var msg = MessageModel.fromJson(result.value);
      msg = msg.copyWith(state: 3);
      await _messageStore.update(await _db, msg.toJson(), finder: Finder(filter: Filter.byKey(result.key)));
    }
  }

  Future _delete() async {
    final finder = Finder(filter: Filter.byKey(1));
    await _messageStore.delete(
      await _db,
      finder: finder,
    );
  }

  void _getAllSortedByName() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [SortOrder('id')], limit: 3, offset: _queryIndex * 3);

    final recordSnapshots = await _messageStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Fruit> out of List<RecordSnapshot>
    var list = recordSnapshots.map((snapshot) {
      final fruit = MessageModel.fromJson(snapshot.value);
      var model = fruit.copyWith(id: snapshot.key);
      print(model.toJson());
      return model;
    }).toList();

    if (list.isEmpty) {
      _queryIndex = 0;
    } else {
      _queryIndex++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sembast"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                _inset();
              },
              child: const Text('inset'),
            ),
            TextButton(
              onPressed: () {
                _update();
              },
              child: const Text('update'),
            ),
            TextButton(
              onPressed: () {
                _delete();
              },
              child: const Text('delete'),
            ),
            TextButton(
              onPressed: () {
                _getAllSortedByName();
              },
              child: const Text('query'),
            ),
          ],
        ),
      ),
    );
  }
}

class AppDatabase {
  // Singleton instance
  static final AppDatabase _singleton = AppDatabase._();

  // Singleton accessor
  static AppDatabase get instance => _singleton;

  // Completer is used for transforming synchronous code into asynchronous code.
  Completer<Database>? _dbOpenCompleter;

  // A private constructor. Allows us to create instances of AppDatabase
  // only from within the AppDatabase class itself.
  AppDatabase._();

  // Database object accessor
  Future<Database> get database async {
    // If completer is null, AppDatabaseClass is newly instantiated, so database is not yet opened
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      // Calling _openDatabase will also complete the completer with database instance
      _openDatabase();
    }
    // If the database is already opened, awaiting the future will happen instantly.
    // Otherwise, awaiting the returned future will take some time - until complete() is called
    // on the Completer in _openDatabase() below.
    return _dbOpenCompleter!.future;
  }

  Future _openDatabase() async {
    // Get a platform-specific directory where persistent app data can be stored
    final appDocumentDir = await getApplicationDocumentsDirectory();
    // Path with the form: /platform-specific-directory/demo.db
    final dbPath = join(appDocumentDir.path, 'demo.db');

    final database = await databaseFactoryIo.openDatabase(dbPath);
    // Any code awaiting the Completer's future will now start executing
    _dbOpenCompleter?.complete(database);
  }
}
