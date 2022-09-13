import 'package:fluent_ui/fluent_ui.dart';
import 'package:firedart/firedart.dart';

// void main() => runApp(FireStoreApp());

const apiKey = 'AIzaSyDpMoVaa_Y8LGoKn8sp-C_PXcb7z1Jdcpg';
const projectId = 'awt-inventory-system';

class FireStoreApp extends StatelessWidget {
  const FireStoreApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FluentApp(
      title: 'Cloud Firestore Windows',
      home: FireStoreHome(),
    );
  }
}

class FireStoreHome extends StatefulWidget {
  const FireStoreHome({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FireStoreHomeState createState() => _FireStoreHomeState();
}

class _FireStoreHomeState extends State<FireStoreHome> {
  CollectionReference groceryCollection =
      Firestore.instance.collection('groceries');

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Button(
              child: const Text('List Groceries'),
              onPressed: () async {
                final groceries = await groceryCollection.get();

                // ignore: avoid_print
                print(groceries);
              },
            ),
            Button(
              child: const Text('Add Grocery Item'),
              onPressed: () async {
                await groceryCollection.add({
                  'fruit': 'bananas',
                });
                // ignore: avoid_print
                print("Add item button pressed.");
              },
            ),
            Button(
              child: const Text('Edit Grocery Item'),
              onPressed: () async {
                await groceryCollection
                    .document('9MJj6DrWkao10D5lWgZY')
                    .update({
                  'fruit': 'Apples!',
                });
                // ignore: avoid_print
                print('Edit Grocery item button pressed.');
              },
            ),
            Button(
              child: const Text('Delete Grocery Item'),
              onPressed: () async {
                await groceryCollection
                    .document('x3qQrSLNKeqvbhjg6O1P')
                    .delete();

                // ignore: avoid_print
                print('Delete Grocery Item Button Pressed.');
              },
            ),
          ],
        ), // Column
      ), // Center
    );
  }
}
