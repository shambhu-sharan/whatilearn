import 'dart:math';

import 'package:admin_dashboard/extension/app_localizations_context.dart';
import 'package:admin_dashboard/helper.dart';
import 'package:admin_dashboard/widgets/inventory/custom_text_field.dart';
import 'package:flutter/material.dart';

import '../../../widgets/inventory/sized_box.dart';

/// Flutter code sample for [SliverAnimatedList].

void main() => runApp(const SliverAnimatedListSample());

class SliverAnimatedListSample extends StatefulWidget {
  const SliverAnimatedListSample({super.key});

  @override
  State<SliverAnimatedListSample> createState() =>
      _SliverAnimatedListSampleState();
}

class _SliverAnimatedListSampleState extends State<SliverAnimatedListSample> {
  final GlobalKey<SliverAnimatedListState> _listKey =
  GlobalKey<SliverAnimatedListState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();
  late ListModel<int> _list;
  int? _selectedItem;
  late int
  _nextItem; // The next item inserted when the user presses the '+' button.

  @override
  void initState() {
    super.initState();
    _list = ListModel<int>(
      listKey: _listKey,
      initialItems: <int>[0, 1, 2],
      removedItemBuilder: _buildRemovedItem,
    );
    _nextItem = 3;
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return /*CardItem(
      animation: animation,
      item: _list[index],
      selected: _selectedItem == _list[index],
      onTap: () {
        setState(() {
          _selectedItem = _selectedItem == _list[index] ? null : _list[index];
        });
      },
    )*/
      Row(
        children: [
          const SizedBox(width: 60, height: 35),
          FxBox.w10,
          SizedBox(width: 100,child: Text('sNo', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          FxBox.w20,
          Expanded(
              flex: 5,
              child: Text('part_', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          FxBox.w20,
          Expanded(
              flex: 2,
              child: Text('hsn_code', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          FxBox.w20,
          // Expanded(child:Text('mrp, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          //  FxBox.w20,
          Expanded(child: Text('quantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          FxBox.w20,
          Expanded(child: Text('discount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          FxBox.w20,
          Expanded(child: Text('price', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          FxBox.w20,
          Expanded( child: Text('tax_', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          FxBox.w20,
          Expanded(child: Text('tax_', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          FxBox.w20,
          Expanded(
              child: SizedBox(height:35,child: CustomTextField(labelText: "",hintText: "",isValidate: true,))),
          FxBox.w20,
          Expanded(child: Text('amount', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            SizedBox(width: 58,)
          //  Expanded(child:Text("${'supplier} ${'name}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
        ],
      );
  }

  /// The builder function used to build items that have been removed.
  ///
  /// Used to build an item after it has been removed from the list. This method
  /// is needed because a removed item remains visible until its animation has
  /// completed (even though it's gone as far this ListModel is concerned). The
  /// widget will be used by the [AnimatedListState.removeItem] method's
  /// [AnimatedRemovedItemBuilder] parameter.
  Widget _buildRemovedItem(int item, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
    );
  }

  // Insert the "next item" into the list model.
  void _insert() {
    final int index =
    _selectedItem == null ? _list.length : _list.indexOf(_selectedItem!);
    _list.insert(index, _nextItem++);
  }

  // Remove the selected item from the list model.
  void _remove() {
    if (_selectedItem != null) {
      _list.removeAt(_list.indexOf(_selectedItem!));
      setState(() {
        _selectedItem = null;
      });
    } else {
      _scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text(
          'Select an item to remove from the list.',
          style: TextStyle(fontSize: 20),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      scrollBehavior: MyCustomScrollBehavior(),
      home: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [

            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: 600,
                width: max(MediaQuery.sizeOf(context).width, 1200),
                child: CustomScrollView(
                  physics:AlwaysScrollableScrollPhysics(),
                  slivers: <Widget>[
              /*      SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: YourHorizontalContentWidget(),
                      ),
                    ),*/
                    SliverAppBar(
                      pinned: true,
                      toolbarHeight: 35,
                      title: Row(
                        children: [
                         // const SizedBox(width: 35, height: 35),
                         // FxBox.w10,
                          SizedBox(width: 100,child: Text('sNo', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          FxBox.w20,
                          Expanded(
                              flex: 5,
                              child: Text('part_', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          FxBox.w20,
                          Expanded(
                              flex: 2,
                              child: Text('hsn_code', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          FxBox.w20,
                          // Expanded(child:Text('mrp, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          //  FxBox.w20,
                          Expanded(child: Text('quantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          FxBox.w20,
                          Expanded(child: Text('discount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          FxBox.w20,
                          Expanded(child: Text('price', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          FxBox.w20,
                          Expanded( child: Text('tax_', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          FxBox.w20,
                          Expanded(child: Text('tax_', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          FxBox.w20,
                          Expanded(
                              child: Text('taxable', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          FxBox.w20,
                          Expanded(child: Text('amount', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          //  FxBox.w20,
                          //  Expanded(child:Text("${'supplier} ${'name}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        ],
                      ),
                      expandedHeight: 10,
                      centerTitle: true,
                      backgroundColor: Colors.amber[900],
                    leading: IconButton(
                        icon: const Icon(Icons.add_circle),
                        onPressed: _insert,
                        tooltip: 'Insert a new item.',
                        iconSize: 15,
                      ),
                         actions: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.remove_circle),
                          onPressed: _remove,
                          tooltip: 'Remove the selected item.',
                          iconSize: 15,
                        ),
                      ],
                    ),
                    SliverAnimatedList(
                      key: _listKey,
                      initialItemCount: _list.length,
                      itemBuilder: _buildItem,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

typedef RemovedItemBuilder<E> = Widget Function(E item, BuildContext context, Animation<double> animation);

// Keeps a Dart [List] in sync with an [AnimatedList].
//
// The [insert] and [removeAt] methods apply to both the internal list and
// the animated list that belongs to [listKey].
//
// This class only exposes as much of the Dart List API as is needed by the
// sample app. More list methods are easily added, however methods that
// mutate the list must make the same changes to the animated list in terms
// of [AnimatedListState.insertItem] and [AnimatedList.removeItem].
class ListModel<E> {
  ListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<SliverAnimatedListState> listKey;
  final RemovedItemBuilder<E> removedItemBuilder;
  final List<E> _items;

  SliverAnimatedListState get _animatedList => listKey.currentState!;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index, (BuildContext context, Animation<double> animation) => removedItemBuilder(removedItem, context, animation),
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

// Displays its integer item as 'Item N' on a Card whose color is based on
// the item's value.
//
// The card turns gray when [selected] is true. This widget's height
// is based on the [animation] parameter. It varies as the animation value
// transitions from 0.0 to 1.0.
class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    this.onTap,
    this.selected = false,
    required this.animation,
    required this.item,
  }) : assert(item >= 0);

  final Animation<double> animation;
  final VoidCallback? onTap;
  final int item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 2.0,
        right: 2.0,
        top: 2.0,
      ),
      child: SizeTransition(
        sizeFactor: animation,
        child: GestureDetector(
          onTap: onTap,
          child: SizedBox(
            height: 80.0,
            child: Card(
              color: selected
                  ? Colors.black12
                  : Colors.primaries[item % Colors.primaries.length],
              child: Center(
                child: Text(
                  'Item $item',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
