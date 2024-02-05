
import 'package:admin_dashboard/constants/region_constant.dart';
import 'package:admin_dashboard/core/controllers/purchase_order/purchase_order_controller.dart';
import 'package:admin_dashboard/core/models/purchase_order/part_detail_invoice.dart';
import 'package:admin_dashboard/extension/app_localizations_context.dart';
import 'package:admin_dashboard/widgets/generic/auto_complete_future.dart';
import 'package:admin_dashboard/widgets/inventory/custom_button.dart';
import 'package:admin_dashboard/widgets/inventory/sized_box.dart';
import 'package:admin_dashboard/widgets/quantity_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/color.dart';
import '../../../services/inventory/inventory_service.dart';
import '../../../utils/string_util.dart';
import '../../../widgets/autocomplete/supplier_autocomplete_widget/supplier_autocomplete_widget.dart';
import '../../../widgets/discount_widget.dart';
import '../../../widgets/generic/auto_complete.dart';
import '../../../widgets/generic/main_body_widget.dart';
import '../../../widgets/inventory/custom_text_field.dart';
import '../../../widgets/inventory/date_picker.dart';
import '../../../widgets/inventory/part_master_autocomplete.dart';
import '../../../widgets/tax_widget.dart';
import '../../controllers/navigation_controller.dart';
import '../../models/inventory/workshop_dropdown.dart';

class PurchaseOrder extends StatefulWidget {
  const PurchaseOrder({super.key});

  @override
  State<PurchaseOrder> createState() => _PurchaseOrderState();
}

class _PurchaseOrderState extends State<PurchaseOrder> {
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey<SliverAnimatedListState>();
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  PartDetailsInvoice? _partDetailsInvoice;
  final _purchaseOrderController = Get.find<PurchaseOrderController>();
  final List<PartDetailsInvoice> _items = [];


  @override
  Widget build(BuildContext context) {
    return createMainBody(
        context,
        context.local.purchase,
        PageIndex.CREATE_PURCHASE_ORDER,
        Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: DatePicker(
                                isShowDefaultDate: true,
                                labelText: "${context.local.transfer} ${context.local.date}",
                                allowDatePiker: false,
                              ),
                            ),
                            FxBox.w20,
                            Flexible(
                              child: CustomAutoCompleteFuture(
                                  inventoryService.getWorkshopList(), (Object option) => (option as WorkshopDropdown).shopName,
                                  labelText: "${context.local.warehouse}/${context.local.workshop} ${context.local.from}",
                                  isMandatory: true, callBack: (data) {
                                if (data != null) {
                                  WorkshopDropdown workShop = data;
                                }
                              }),
                            ),
                            FxBox.w20,
                            Flexible(child: SupplierAutoComplete((supplier) {})),
                          ],
                        ),
                        FxBox.h10,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 2,
                                child: PartMasterAutoComplete((partMaster) {
                                  _partDetailsInvoice = PartDetailsInvoice(partMaster);
                                }, isMandatory: false)),
                            FxBox.w20,
                            Expanded(
                                child: CustomTextField(
                              labelText: context.local.price,
                              prefixText: '${RegionConstants.activeRegion.currencySymbol} ',
                            )),
                            FxBox.w20,
                            Expanded(
                                child: QuantityWidget((value) {

                                },measurementUnit : ()=> 'Kg')),
                            FxBox.w20,
                             Expanded(child: DiscountWidget((value) => {})),
                            FxBox.w20,
                             Expanded(child: TaxWidget((value) => {})),
                            FxBox.w20,
                            CustomButton(
                              borderRadius: 4,
                              onPressed: () => addReceivedItem(context),
                              text: context.local.add,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  FxBox.h20,
                  sparePartList(context),
                ],
              ),
            )));
  }

  Widget sparePartList(BuildContext context) {
    return MediaQuery.sizeOf(context).width > 1000 ? _listWidget() : SingleChildScrollView(scrollDirection: Axis.horizontal, child: _listWidget());
  }

  Widget _listWidget() {
    return SizedBox(
        height: 500,
        width: MediaQuery.sizeOf(context).width,
        child: CustomScrollView(controller: _scrollController, physics: const ClampingScrollPhysics(), slivers: <Widget>[
          SliverAppBar(
              pinned: true,
              toolbarHeight: 35,
              title: Row(children: [
                const SizedBox(width: 25, height: 25),
                FxBox.w10,
                getColumn(context.local.sNo, textAlign: TextAlign.center, width: 50, isHeader: true),
                FxBox.w20,
                getColumn(context.local.part_(context.local.description), isHeader: true, textAlign: TextAlign.left),
                FxBox.w20,
                getColumn(context.local.hsn_code, width: 80, isHeader: true),
                FxBox.w20,
                getColumn(context.local.price, width: 100, isHeader: true),
                FxBox.w20,
                getColumn(context.local.quantity, width: 80, isHeader: true),
                FxBox.w20,
                getColumn(context.local.taxable_(context.local.amount), textAlign: TextAlign.right, width: 100, isHeader: true),
                FxBox.w20,
                getColumn(context.local.tax_(context.local.amount), textAlign: TextAlign.right, width: 110, isHeader: true),
                FxBox.w20,
                getColumn(context.local.discount, isHeader: true, width: 100),
                FxBox.w20,
                getColumn(context.local.total, textAlign: TextAlign.right, width: 100, isHeader: true),
              ]),
              expandedHeight: 10,
              centerTitle: true,
              backgroundColor: Colors.green.shade100),
          SliverAnimatedList(
            key: _listKey,
            initialItemCount: _items.length,
            itemBuilder: _buildItem,
          )
        ]));
  }

  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    PartDetailsInvoice item = _items[index];
    return SizeTransition(
        key: UniqueKey(),
        sizeFactor: animation,
        child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Card(
                color: ColorConst.footerLight,
                elevation: 10,
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(children: [
                      InkWell(
                          onTap: () => {_removeItem(context, index)},
                          child: SizedBox(width: 25, height: 25, child: Icon(Icons.delete, color: ColorConst.errorDark))),
                      FxBox.w10,
                      getColumn(width: 50, (index + 1).toStringAsFixed(0), textAlign: TextAlign.center),
                      FxBox.w20,
                      Expanded(
                        child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '${item.partMaster.partName}\n',
                                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                                TextSpan(
                                    text: item.partMaster.partDescription,
                                    style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 10))
                              ],
                            )),
                      ),
                      FxBox.w20,
                      getColumn(width: 110, item.hashCode.toString()),
                      FxBox.w20,
                      getColumn(width: 80, item.partMaster.latestMrp.toStringAsFixed(2)),
                      FxBox.w20,
                      getColumn(width: 100, item.quantity.toStringAsFixed(0)),
                      FxBox.w20,
                      getColumn(width: 80, item.taxableAmount.toStringAsFixed(2)),
                      FxBox.w20,
                      getColumn(width: 100, item.taxAmount.toStringAsFixed(2)),
                      FxBox.w20,
                      getColumn(width: 100, item.discountAmount.toStringAsFixed(2)),
                      FxBox.w20,
                      getColumn(width: 100, item.totalAmount.toStringAsFixed(2)),
                    ])))));
  }

  void _removeItem(BuildContext context, int index) {
    builder(context, animation) {
      return _buildItem(context, index, animation);
    }

    _listKey.currentState!.removeItem(index, builder);
  }

  void _addItem(PartDetailsInvoice spareModelNew) {
    int index = _items.isNotEmpty ? _items.length : 0;
    _items.insert(index, spareModelNew);
    _listKey.currentState!.insertItem(index);
    Future.delayed(const Duration(milliseconds: 1000), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(microseconds: 300), curve: Curves.easeInOut);
    });
  }

  void update(BuildContext context, int index) {
    _listKey.currentState?.removeItem(index, duration: Duration.zero, (context, animation) => _buildItem(context, index, animation));
    _listKey.currentState?.insertItem(index, duration: Duration.zero);
  }

  String getDescription(PartDetailsInvoice item) {
    List<String?> list = [item.partMaster.partDescription];
    return StringUtil.getJoinedString(list);
  }

  String getTitle(PartDetailsInvoice item) {
    List<String?> list = [item.partMaster.partName];
    return StringUtil.getJoinedString(list);
  }

  Widget getColumn(String headerTitle, {TextAlign textAlign = TextAlign.right, int flex = 1, double? width, bool isHeader = false}) {
    Widget child = Text(headerTitle,
        textAlign: textAlign,
        style: isHeader ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 12) : const TextStyle(fontWeight: FontWeight.w400, fontSize: 13));
    if (width != null) {
      return SizedBox(width: width, child: child);
    } else {
      return Expanded(flex: flex, child: child);
    }
  }

  addReceivedItem(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_partDetailsInvoice != null) {
        int existingIndex = _items.indexWhere((item) => item.partMaster.partNo == _partDetailsInvoice!.partMaster.partNo);
        if (existingIndex == -1) {
          _addItem(_partDetailsInvoice!);
        } else {
          update(context, existingIndex);
        }
      }
    }
  }
}

