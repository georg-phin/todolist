import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';


const bool __printDebug = false;

typedef PickerSelectedCallback = void Function(
    Picker picker, int index, List<int> selecteds);

typedef PickerConfirmCallback = void Function(
    Picker picker, List<int> selecteds);

typedef PickerValueFormat<T> = String Function(T value);

class Picker {
  static const double DefaultTextSize = 20.0;

  List<int> selecteds;

  final PickerAdapter adapter;

  final List<PickerDelimiter> delimiter;

  final VoidCallback onCancel;
  final PickerSelectedCallback onSelect;
  final PickerConfirmCallback onConfirm;

  final changeToFirst;

  final List<int> columnFlex;

  final Widget title;
  final Widget cancel;
  final Widget confirm;
  final String cancelText;
  final String confirmText;

  final double height ;

  final double itemExtent;

  final TextStyle textStyle,
      cancelTextStyle,
      confirmTextStyle,
      selectedTextStyle;
  final TextAlign textAlign;

  final double textScaleFactor;

  final EdgeInsetsGeometry columnPadding;
  final Color backgroundColor, headercolor, containerColor;

  final bool hideHeader;

  final bool reversedOrder;

  final bool looping;

  final Widget footer;


  Widget _widget;
  PickerWidgetState _state;

  Picker({
    this.adapter,
    this.delimiter,
    this.selecteds,
    this.height = 150.0,
    this.itemExtent = 28.0,
    this.columnPadding,
    this.textStyle,
    this.cancelTextStyle,
    this.confirmTextStyle,
    this.selectedTextStyle,
    this.textAlign = TextAlign.start,
    this.textScaleFactor,
    this.title,
    this.cancel,
    this.confirm,
    this.cancelText,
    this.confirmText,
    this.backgroundColor = Colors.white,
    this.containerColor= Colors.white,
    this.headercolor,
    this.changeToFirst = false,
    this.hideHeader = false,
    this.looping = false,
    this.reversedOrder = false,
    //this.headerDecoration,
    this.columnFlex,
    this.footer,
    this.onCancel,
    this.onSelect,
    this.onConfirm,
  }) : assert(adapter != null);

  Widget get widget => _widget;
  PickerWidgetState get state => _state;
  int _maxLevel = 1;

  Widget makePicker([ThemeData themeData, bool isModal = false]) {
    _maxLevel = adapter.maxLevel;
    adapter.picker = this;
    adapter.initSelects();
    _widget =
        _PickerWidget(picker: this, themeData: themeData, isModal: isModal);
    return _widget;
  }

  /// show picker
  void show(ScaffoldState state, [ThemeData themeData]) {
    print(height);
    state.showBottomSheet((BuildContext context,)=> GestureDetector(
          onVerticalDragStart: (_) {}, child: Container(height:height+25+70 ,
                      child: Column(
              children: [
                makePicker(themeData),
                Container(color:Colors.white,height: 25,)
              ],
            ),
          ),)
    , backgroundColor: Colors.transparent);
  }

  List getSelectedValues()=>adapter.getSelectedValues();
  

  
  void doCancel(BuildContext context) {
    if (onCancel != null) onCancel();
    Navigator.of(context).pop<List<int>>(null);
    _widget = null;
  }


  void doConfirm(BuildContext context) {
    if (onConfirm != null) onConfirm(this, selecteds);

    Navigator.pop(context);

    _widget = null;
  }
}


class PickerDelimiter {
  final Widget child;
  final int column;
  PickerDelimiter({this.child, this.column = 1}) : assert(child != null);
}


class PickerItem<T> {
  
  final Widget text;

 
  final T value;


  final List<PickerItem<T>> children;

  PickerItem({this.text, this.value, this.children});
}

class _PickerWidget<T> extends StatefulWidget {
  final Picker picker;
  final ThemeData themeData;
  final bool isModal;
  _PickerWidget(
      {Key key, @required this.picker, @required this.themeData, this.isModal})
      : super(key: key);

  @override
  PickerWidgetState createState() =>
      PickerWidgetState<T>(picker: this.picker, themeData: this.themeData);
}

class PickerWidgetState<T> extends State<_PickerWidget> {
  final Picker picker;
  final ThemeData themeData;
  PickerWidgetState({Key key, @required this.picker, @required this.themeData});

  ThemeData theme;
  final List<FixedExtentScrollController> scrollController = [];

  @override
  void initState() {
    super.initState();
    theme = themeData;
    picker._state = this;
    picker.adapter.doShow();

    if (scrollController.length == 0) {
      for (int i = 0; i < picker._maxLevel; i++)
        scrollController
            .add(FixedExtentScrollController(initialItem: picker.selecteds[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
     final _mi = MediaQuery.of(context);
    // final double _topi = _mi.padding.top;
    final mediaQuery = _mi.size;
    final double _wi = mediaQuery.width;
    var v = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // const SizedBox(height: 12),
         Container(
            
            child: Stack(
              children: [
                Positioned(top:12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          height: 48,width: _wi,
                          alignment: Alignment.center,
                          child: picker.title)
                    ],
                  ),
                ),
                // const SizedBox(height:12),
               Container(width: _wi,margin: EdgeInsets.only(top:12),
                                child: Row(
                        children: _buildHeaderViews(),
                      ),
               ),
                               
              
                
              ],
            ),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0))),
          ),
      
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _buildViews(),
        ),
        picker.footer ?? SizedBox(width: 0.0, height: 0.0),
      ],
    );
    if (widget.isModal == null || widget.isModal == false) return v;
    return GestureDetector(
      onTap: () {},
      child: v,
    );
  }

  List<Widget> _buildHeaderViews() {
    if (theme == null) theme = Theme.of(context);
    List<Widget> items = [];

    if (picker.cancel != null) {
      items.add(DefaultTextStyle(
          style: picker.cancelTextStyle ??
              TextStyle(
                  color: theme.accentColor, fontSize: Picker.DefaultTextSize),
          child: picker.cancel));
    } else {
      String _cancelText = picker.cancelText;
      if (_cancelText != null || _cancelText != "") {
        items.add(FlatButton(
            onPressed: () {
              picker.doCancel(context);
            },
            child: Text(_cancelText,
                overflow: TextOverflow.ellipsis,
                style: picker.cancelTextStyle ??
                    TextStyle(
                        color: theme.accentColor,
                        fontSize: Picker.DefaultTextSize))));
      }
    }

    items.add(Expanded(
        child: Container(
      alignment: Alignment.center,
    )));

    if (picker.confirm != null) {
      items.add(DefaultTextStyle(
          style: picker.confirmTextStyle ??
              TextStyle(
                  color: theme.accentColor, fontSize: Picker.DefaultTextSize),
          child: picker.confirm));
    } else {
      String _confirmText = picker.confirmText;
      if (_confirmText != null || _confirmText != "") {
        items.add(Padding(
          padding: const EdgeInsets.only(right:6.0),
          child: FlatButton(
              onPressed: () {
                picker.doConfirm(context);
              },
              child: Text(_confirmText,
                  overflow: TextOverflow.ellipsis,
                  style: picker.confirmTextStyle ??
                      TextStyle(
                          color: theme.accentColor,
                          fontSize: Picker.DefaultTextSize))),
        ));
      }
    }

    return items;
  }

  bool _changeing = false;
  final Map<int, int> lastData = {};

  List<Widget> _buildViews() {
    if (__printDebug) print("_buildViews");
    if (theme == null) theme = Theme.of(context);

    List<Widget> items = [];

    PickerAdapter adapter = picker.adapter;
    if (adapter != null) adapter.setColumn(-1);

    if (adapter != null && adapter.length > 0) {
      for (int i = 0; i < picker._maxLevel; i++) {
        final int _length = adapter.length;

        Widget view = new Expanded(
          flex: adapter.getColumnFlex(i),
          child: Container(
            // margin:EdgeInsets.only(top:10),
            padding: picker.columnPadding,
            height: picker.height,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                scrollController: scrollController[i],
                itemExtent: picker.itemExtent,
                looping: picker.looping,
                onSelectedItemChanged: (int index) {
                  if (__printDebug) print("onSelectedItemChanged");
                  setState(() {
                    picker.selecteds[i] = index;
                    updateScrollController(i);
                    adapter.doSelect(i, index);
                    if (picker.changeToFirst) {
                      for (int j = i + 1; j < picker.selecteds.length; j++) {
                        picker.selecteds[j] = 0;
                        scrollController[j].jumpTo(0.0);
                      }
                    }
                    if (picker.onSelect != null)
                      picker.onSelect(picker, i, picker.selecteds);
                  });
                },
                children: List<Widget>.generate(_length, (int index) {
                  return adapter.buildItem(context, index);
                }),
              ),
            ),
          ),
        );
        items.add(view);

        if (!picker.changeToFirst && picker.selecteds[i] >= _length) {
          Timer(Duration(milliseconds: 100), () {
            if (__printDebug) print("timer last");
            scrollController[i].jumpToItem(_length - 1);
          });
        }

        adapter.setColumn(i);
      }
    }
    if (picker.delimiter != null) {
      for (int i = 0; i < picker.delimiter.length; i++) {
        var o = picker.delimiter[i];
        if (o.child == null) continue;
        var item = Container(child: o.child, height: picker.height);
        if (o.column < 0)
          items.insert(0, item);
        else if (o.column >= items.length)
          items.add(item);
        else
          items.insert(o.column, item);
      }
    }

    if (picker.reversedOrder) {
      return items.reversed.toList();
    }

    return items;
  }

  void updateScrollController(int i) {
    if (_changeing || !picker.adapter.isLinkage) return;
    _changeing = true;
    for (int j = 0; j < picker.selecteds.length; j++) {
      if (j != i) {
        if (scrollController[j].position.maxScrollExtent == null) continue;
        scrollController[j].position.notifyListeners();
      }
    }
    _changeing = false;
  }
}


abstract class PickerAdapter<T> {
  Picker picker;

  int getLength();
  int getMaxLevel();
  void setColumn(int index);
  void initSelects();
  Widget buildItem(BuildContext context, int index);

  Widget makeText(Widget child, String text, bool isSel) => new Container(
        alignment: Alignment.center,
        child: DefaultTextStyle(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: picker.textAlign,
            style: picker.textStyle ??
                new TextStyle(
                    color: Colors.black87, fontSize: Picker.DefaultTextSize),
            child: child ??
                new Text(text,
                    textScaleFactor: picker.textScaleFactor,
                    style: (isSel ? picker.selectedTextStyle : null))));
  

  Widget makeTextEx(
      Widget child, String text, Widget postfix, Widget suffix, bool isSel) {
    List<Widget> items = [];
    if (postfix != null) items.add(postfix);
    items.add(child ??
        new Text(text, style: (isSel ? picker.selectedTextStyle : null)));
    if (suffix != null) items.add(suffix);

    var _txtColor = Colors.black87;
    var _txtSize = Picker.DefaultTextSize;
    if (isSel && picker.selectedTextStyle != null) {
      if (picker.selectedTextStyle.color != null)
        _txtColor = picker.selectedTextStyle.color;
      if (picker.selectedTextStyle.fontSize != null)
        _txtSize = picker.selectedTextStyle.fontSize;
    }

    return new Container(
        alignment: Alignment.center,
        child: DefaultTextStyle(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: picker.textAlign,
            style: picker.textStyle ??
                new TextStyle(color: _txtColor, fontSize: _txtSize),
            child: Wrap(
              children: items,
            )));
  }

  String getText() =>getSelectedValues().toString();
  

  List<T> getSelectedValues()=> [];
  

  void doShow() {}
  void doSelect(int column, int index) {}

  int getColumnFlex(int column) => picker.columnFlex != null && column < picker.columnFlex.length? picker.columnFlex[column]:1;
  
  

  int get maxLevel => getMaxLevel();

  
  int get length => getLength();

  String get text => getText();

  bool get isLinkage => getIsLinkage();

  @override
  String toString() => getText();
  

  bool getIsLinkage()=> true;
  

  void notifyDatachanged() {
    if (picker != null && picker.state != null) {
      picker.adapter.doShow();
      picker.adapter.initSelects();
      for (int j = 0; j < picker.selecteds.length; j++)
        picker.state.scrollController[j].jumpToItem(picker.selecteds[j]);
    }
  }
 }


class PickerDataAdapter<T> extends PickerAdapter<T> {
  List<PickerItem<T>> data;
  List<PickerItem<dynamic>> _datas;
  int _maxLevel = -1;
  int _col = 0;
  final bool isArray;

  PickerDataAdapter({List pickerdata, this.data, this.isArray = false}) {
    _parseData(pickerdata);
  }

  @override
  bool getIsLinkage()=> !isArray;
  

  void _parseData(final List pickerData) {
    if (pickerData != null &&
        pickerData.length > 0 &&
        (data == null || data.length == 0)) {
      if (data == null) data = new List<PickerItem<T>>();
      if (isArray) {
        _parseArrayPickerDataItem(pickerData, data);
      } else {
        _parsePickerDataItem(pickerData, data);
      }
    }
  }

  _parseArrayPickerDataItem(List pickerData, List<PickerItem> data) {
    if (pickerData == null) return;
    for (int i = 0; i < pickerData.length; i++) {
      var v = pickerData[i];
      if (!(v is List)) continue;
      List lv = v;
      if (lv.length == 0) continue;

      PickerItem item = new PickerItem<T>(children: List<PickerItem<T>>());
      data.add(item);

      for (int j = 0; j < lv.length; j++) {
        var o = lv[j];
        if (o is T) {
          item.children.add(new PickerItem<T>(value: o));
        } else if (T == String) {
          String _v = o.toString();
          item.children.add(new PickerItem<T>(value: _v as T));
        }
      }
    }
    if (__printDebug) print("data.length: ${data.length}");
  }

  _parsePickerDataItem(List pickerData, List<PickerItem> data) {
    if (pickerData == null) return;
    for (int i = 0; i < pickerData.length; i++) {
      var item = pickerData[i];
      if (item is T) {
        data.add(new PickerItem<T>(value: item));
      } else if (item is Map) {
        final Map map = item;
        if (map.length == 0) continue;

        List<T> _mapList = map.keys.toList();
        for (int j = 0; j < _mapList.length; j++) {
          var _o = map[_mapList[j]];
          if (_o is List && _o.length > 0) {
            List<PickerItem> _children = new List<PickerItem<T>>();
          
            data.add(
                new PickerItem<T>(value: _mapList[j], children: _children));
            _parsePickerDataItem(_o, _children);
          }
        }
      } else if (T == String && !(item is List)) {
        String _v = item.toString();
     
        data.add(new PickerItem<T>(value: _v as T));
      }
    }
  }

  void setColumn(int index) {
    _col = index + 1;
    if (isArray) {
      if (__printDebug) print("index: $index");
      if (index + 1 < data.length)
        _datas = data[index + 1].children;
      else
        _datas = null;
      return;
    }
    if (index < 0) {
      _datas = data;
    } else {
      var _select = picker.selecteds[index];
      if (_datas != null && _datas.length > _select)
        _datas = _datas[_select].children;
      else
        _datas = null;
    }
  }

  @override
  int getLength() {
    return _datas == null ? 0 : _datas.length;
  }

  @override
  getMaxLevel() {
    if (_maxLevel == -1) _checkPickerDataLevel(data, 1);
    return _maxLevel;
  }

  @override
  Widget buildItem(BuildContext context, int index) {
    final PickerItem item = _datas[index];
    if (item.text != null) {
      return item.text;
    }
    return makeText(item.text, item.text != null ? null : item.value.toString(),
        index == picker.selecteds[_col]);
  }

  @override
  void initSelects() {
    if (picker.selecteds == null || picker.selecteds.length == 0) {
      if (picker.selecteds == null) picker.selecteds = new List<int>();
      for (int i = 0; i < _maxLevel; i++) picker.selecteds.add(0);
    }
  }

  @override
  List<T> getSelectedValues() {
    List<T> _items = [];
    if (picker.selecteds != null) {
      if (isArray) {
        for (int i = 0; i < picker.selecteds.length; i++) {
          int j = picker.selecteds[i];
          if (j < 0 || data[i].children == null || j >= data[i].children.length)
            break;
          _items.add(data[i].children[j].value);
        }
      } else {
        List<PickerItem<dynamic>> datas = data;
        for (int i = 0; i < picker.selecteds.length; i++) {
          int j = picker.selecteds[i];
          if (j < 0 || j >= datas.length) break;
          _items.add(datas[j].value);
          datas = datas[j].children;
          if (datas == null || datas.length == 0) break;
        }
      }
    }
    return _items;
  }

  _checkPickerDataLevel(List<PickerItem> data, int level) {
    if (data == null) return;
    if (isArray) {
      _maxLevel = data.length;
      return;
    }
    for (int i = 0; i < data.length; i++) {
      if (data[i].children != null && data[i].children.length > 0)
        _checkPickerDataLevel(data[i].children, level + 1);
    }
    if (_maxLevel < level) _maxLevel = level;
  }
}

class NumberPickerColumn {
  final List<int> items;
  final int begin;
  final int end;
  final int initValue;
  final int columnFlex;
  final int jump;
  final Widget postfix, suffix;
  final PickerValueFormat<int> onFormatValue;

  const NumberPickerColumn({
    this.begin = 0,
    this.end = 9,
    this.items,
    this.initValue,
    this.jump = 1,
    this.columnFlex = 1,
    this.postfix,
    this.suffix,
    this.onFormatValue,
  }) : assert(jump != null);

  int indexOf(int value) {
    if (value == null) return -1;
    if (items != null) return items.indexOf(value);
    if (value < begin || value > end) return -1;
    return (value - begin) ~/ (this.jump == 0 ? 1 : this.jump);
  }

  int valueOf(int index) {
    if (items != null) {
      return items[index];
    }
    return begin + index * (this.jump == 0 ? 1 : this.jump);
  }

  String getValueText(int index) {
    return onFormatValue == null
        ? "${valueOf(index)}"
        : onFormatValue(valueOf(index));
  }

  int count() {
    var v = (end - begin) ~/ (this.jump == 0 ? 1 : this.jump) + 1;
    if (v < 1) return 0;
    return v;
  }
}

class NumberPickerAdapter extends PickerAdapter<int> {
  NumberPickerAdapter({this.data}) : assert(data != null);

  final List<NumberPickerColumn> data;
  NumberPickerColumn cur;
  int _col = 0;

  @override
  int getLength() {
    if (cur == null) return 0;
    if (cur.items != null) return cur.items.length;
    return cur.count();
  }

  @override
  int getMaxLevel() => data == null ? 0 : data.length;
  

  @override
  bool getIsLinkage()=> false;
  

  @override
  void setColumn(int index) {
    _col = index + 1;
    if (index + 1 >= data.length) {
      cur = null;
    } else {
      cur = data[index + 1];
    }
  }

  @override
  void initSelects() {
    int _maxLevel = getMaxLevel();
    if (picker.selecteds == null || picker.selecteds.length == 0) {
      if (picker.selecteds == null) picker.selecteds = new List<int>();
      for (int i = 0; i < _maxLevel; i++) {
        int v = data[i].indexOf(data[i].initValue);
        if (v < 0) v = 0;
        picker.selecteds.add(v);
      }
    }
  }

  @override
  Widget buildItem(BuildContext context, int index) => cur.postfix == null && cur.suffix == null?makeText(
          null, cur.getValueText(index), index == picker.selecteds[_col])
    : makeTextEx(null, cur.getValueText(index), cur.postfix, cur.suffix,
          index == picker.selecteds[_col]);
  

  @override
  int getColumnFlex(int column) => data[column].columnFlex;
  

  @override
  List<int> getSelectedValues() {
    List<int> _items = [];
    if (picker.selecteds != null) {
      for (int i = 0; i < picker.selecteds.length; i++) {
        int j = picker.selecteds[i];
        int v = data[i].valueOf(j);
        _items.add(v);
      }
    }
    return _items;
  }
}
